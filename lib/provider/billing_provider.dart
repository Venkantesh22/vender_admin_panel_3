


import 'package:flutter/foundation.dart';
import 'dart:math';

enum DiscountOrder { fixedThenPercent, percentThenFixed }

class BillingProvider extends ChangeNotifier {
  // Inputs
  double serviceSubtotal = 0.0; // gross services
  double serviceDiscount = 0.0; // existing service discount (rs)
  double productSubtotal = 0.0; // gross products
  double productDiscount = 0.0; // existing product discount (rs)

  // Flags (kept for compatibility)
  bool serviceIsGstInclusive = false; // toggleable
  final bool productIsGstInclusive = true;

  // GST
  double gstPercent = 18.0;

  // NEW: store the service GST type string from your model (can be "Inclusive", "Exclusive", null, or empty)
  String? serviceGstType;

  // Extra discounts (UI sets)
  double extraFixed = 0.0; // user-entered fixed rupee discount
  double extraPercent = 0.0; // user-entered percent (0..100)
  DiscountOrder discountOrder = DiscountOrder.fixedThenPercent;

  // Computed outputs
  double subtotal = 0.0;
  double existingDiscountTotal = 0.0; // serviceDiscount + productDiscount
  double netPrice = 0.0; // subtotal - totalDiscountApplied

  double taxableAmount = 0.0;
  double gstAmount = 0.0;
  double finalTotal = 0.0;

  // allocation details (exposed for UI / persistence)
  double allocatedFixedToService = 0.0;
  double allocatedFixedToProduct = 0.0;
  double allocatedPercentToService = 0.0;
  double allocatedPercentToProduct = 0.0;

  BillingProvider();

  // ----------------- init (unchanged signature) -----------------
  void init({
    required double serviceSubtotalIn,
    required double serviceDiscountIn,
    required double productSubtotalIn,
    required double productDiscountIn,
    required bool serviceGstInclusive, // keep same signature for UI compatibility
    double gstPercentIn = 18.0,
  }) {
    serviceSubtotal = serviceSubtotalIn;
    serviceDiscount = serviceDiscountIn;
    productSubtotal = productSubtotalIn;
    productDiscount = productDiscountIn;
    serviceIsGstInclusive = serviceGstInclusive;
    gstPercent = gstPercentIn;

    // note: you should still call configureGstFromModel(...) after init when your model has the string
    _compute();
  }

  /// NEW helper: configure GST using the string from your stored model.
  /// Pass whatever value is in `_appointModel.serviceBillModel?.gstIsIncludingOrExcluding`
  /// - if `gstType == null || gstType.isEmpty` -> treat as NO GST (gstPercent = 0)
  /// - if gstType == 'Inclusive' -> serviceIsGstInclusive = true
  /// - if gstType == 'Exclusive' -> serviceIsGstInclusive = false
  ///
  /// `settingsGstPercent` should be your salon / global GST percent (e.g. 18.0).
  void configureGstFromModel(String? gstType, double settingsGstPercent) {
    serviceGstType = gstType;
    if (gstType == null || gstType.trim().isEmpty) {
      // no GST at all
      gstPercent = 0.0;
      serviceIsGstInclusive = false; // treat as not inclusive (no GST)
    } else {
      // GST exists — set percent from settings and flags from type
      gstPercent = settingsGstPercent;
      serviceIsGstInclusive = gstType.toLowerCase() == 'inclusive';
    }
    _compute();
  }

  // Setters for UI
  void setExtraFixed(double v) {
    extraFixed = max(0.0, v);
    _compute();
  }

  void setExtraPercent(double v) {
    extraPercent = v.clamp(0.0, 100.0);
    _compute();
  }

  void setDiscountOrder(DiscountOrder o) {
    discountOrder = o;
    _compute();
  }

  void setServiceDiscount(double v) {
    serviceDiscount = max(0.0, v);
    _compute();
  }

  void setProductDiscount(double v) {
    productDiscount = max(0.0, v);
    _compute();
  }

  // inside BillingProvider after computation
  double extraFixedApplied = 0.0; // set this in _compute()
  double extraPercentApplied = 0.0; // set this in _compute()

  double get getExtraFixedApplied => extraFixedApplied;
  double get getExtraPercentApplied => extraPercentApplied;
  double get getExtraTotalApplied => (extraFixedApplied + extraPercentApplied);

  // ----------------- getters for UI and persistence -----------------
  double get getTotalDiscount => _round2(totalDiscountApplied);

  double get getSubtotal => subtotal;
  double get getExistingDiscount =>
      existingDiscountTotal; // existing (before extra)
  double get getExtraFixedAllocatedToService => allocatedFixedToService;
  double get getExtraFixedAllocatedToProduct => allocatedFixedToProduct;
  double get getExtraPercentAllocatedToService => allocatedPercentToService;
  double get getExtraPercentAllocatedToProduct => allocatedPercentToProduct;
  double get getExtraAppliedTotal => (allocatedFixedToService +
      allocatedFixedToProduct +
      allocatedPercentToService +
      allocatedPercentToProduct); // amount of extra discounts
  double get getTotalDiscountApplied =>
      _round2(existingDiscountTotal + getExtraAppliedTotal);
  double get getNetPrice => netPrice; // subtotal - totalDiscountApplied
  double get getTaxableAmount => taxableAmount;
  double get getGstAmount => gstAmount;
  double get getFinalTotal => finalTotal;

  // NEW getters to help UI
  bool get isServiceGstConfigured =>
      serviceGstType != null && serviceGstType!.trim().isNotEmpty;
  String get serviceGstConfiguredType =>
      serviceGstType == null ? 'None' : serviceGstType!;

  // ----------------- internal compute -----------------
  double _round2(double v) => v;

  void _compute() {
    final r = gstPercent / 100.0;
    subtotal = _round2(serviceSubtotal + productSubtotal);
    existingDiscountTotal = _round2(serviceDiscount + productDiscount);

    // raw nets after existing discounts (these are the visible nets)
    final rawServiceNet = max(0.0, serviceSubtotal - serviceDiscount);
    final rawProductNet = max(0.0, productSubtotal - productDiscount);

    // Reset allocations
    allocatedFixedToService = 0.0;
    allocatedFixedToProduct = 0.0;
    allocatedPercentToService = 0.0;
    allocatedPercentToProduct = 0.0;

    // Helper: proportionally allocate 'amount' between a and b
    Map<String, double> _allocProportional(double a, double b, double amount) {
      final total = a + b;
      if (total <= 0 || amount <= 0) return {'a': 0.0, 'b': 0.0};
      final aAlloc = (a / total) * amount;
      final bAlloc = amount - aAlloc; // preserve total
      return {'a': aAlloc, 'b': bAlloc};
    }

    // --- NEW ALLOCATION STRATEGY ---
    // To match the manual calculations you used earlier:
    // - percent discounts are computed based on the baseline visible nets (service+product) and NOT on the remaining after fixed allocation.
    // - when both fixed and percent are present, we compute the fixed amount and the percent amount separately and allocate BOTH proportionally to the baseline visible nets.
    // This yields the "combined proportional" allocation and matches the expected outputs for the three cases (fixed only, percent only, both).

    final double totalVisibleNet = rawServiceNet + rawProductNet;
    final double percentAmountTotal = (extraPercent > 0.0)
        ? (totalVisibleNet * (extraPercent / 100.0))
        : 0.0;

    double fixedSvcAllocated = 0.0;
    double fixedProdAllocated = 0.0;
    double pctSvcAllocated = 0.0;
    double pctProdAllocated = 0.0;

    if (extraFixed > 0.0 && extraPercent > 0.0) {
      // allocate fixed and percent separately but both using the baseline proportions
      final fixedAlloc = _allocProportional(rawServiceNet, rawProductNet, extraFixed);
      fixedSvcAllocated = fixedAlloc['a']!;
      fixedProdAllocated = fixedAlloc['b']!;

      final pctAlloc = _allocProportional(rawServiceNet, rawProductNet, percentAmountTotal);
      pctSvcAllocated = pctAlloc['a']!;
      pctProdAllocated = pctAlloc['b']!;
    } else if (extraFixed > 0.0) {
      final fixedAlloc = _allocProportional(rawServiceNet, rawProductNet, extraFixed);
      fixedSvcAllocated = fixedAlloc['a']!;
      fixedProdAllocated = fixedAlloc['b']!;
    } else if (extraPercent > 0.0) {
      final pctAlloc = _allocProportional(rawServiceNet, rawProductNet, percentAmountTotal);
      pctSvcAllocated = pctAlloc['a']!;
      pctProdAllocated = pctAlloc['b']!;
    }

    // Assign allocated fields (round only for display/storage; keep internal precision for calculations)
    allocatedFixedToService = _round2(fixedSvcAllocated);
    allocatedFixedToProduct = _round2(fixedProdAllocated);
    allocatedPercentToService = _round2(pctSvcAllocated);
    allocatedPercentToProduct = _round2(pctProdAllocated);

    // track applied discounts (unrounded sums are kept for internal accounting, but we expose rounded)
    extraFixedApplied = fixedSvcAllocated + fixedProdAllocated;
    extraPercentApplied = pctSvcAllocated + pctProdAllocated;

    // Final nets after both extra discounts (use unrounded allocations to avoid small drift)
    final double finalServiceNet = max(0.0, rawServiceNet - (fixedSvcAllocated + pctSvcAllocated));
    final double finalProductNetInclusive = max(0.0, rawProductNet - (fixedProdAllocated + pctProdAllocated));

    // Tax computations
    double taxableService;
    double gstService;
    if (gstPercent <= 0.0) {
      // No GST at all
      taxableService = finalServiceNet;
      gstService = 0.0;
    } else if (serviceIsGstInclusive) {
      // service is stored/displayed inclusive -> extract taxable and gst
      taxableService = finalServiceNet / (1 + r);
      gstService = finalServiceNet - taxableService;
    } else {
      // GST exclusive service
      taxableService = finalServiceNet;
      gstService = taxableService * r;
    }

    final double taxableProduct = gstPercent <= 0.0
        ? finalProductNetInclusive
        : finalProductNetInclusive / (1 + r);
    final double gstProduct = gstPercent <= 0.0 ? 0.0 : finalProductNetInclusive - taxableProduct;

    taxableAmount = _round2(taxableService + taxableProduct);
    gstAmount = _round2(gstService + gstProduct);

    // final total: service final (taxable+gst) + product final (inclusive)
    final double finalServiceAmount = _round2(taxableService + gstService);
    final double finalProductAmount = _round2(finalProductNetInclusive);
    finalTotal = _round2(finalServiceAmount + finalProductAmount);

    // total discounts applied
    final double extraApplied = extraFixedApplied + extraPercentApplied;
    totalDiscountApplied = _round2(existingDiscountTotal + extraApplied);

    netPrice = _round2(subtotal - totalDiscountApplied);

    notifyListeners();
  }

  // stored for UI
  double totalDiscountApplied = 0.0;
}
