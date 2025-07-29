import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// void main() => runApp(SamayPitchDeck());

class SamayPitchDeck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Samay Pitch Deck',
      home: PitchDeckPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PitchDeckPage extends StatefulWidget {
  @override
  _PitchDeckPageState createState() => _PitchDeckPageState();
}

class _PitchDeckPageState extends State<PitchDeckPage> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: [
          CoverSlide(),
          CompanyOverviewSlide(),
          ProblemBusinessSlide(),
          SolutionPeopleSlide(),
          ContactSlide(),
        ],
      ),
    );
  }
}

class CoverSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF2E6A50),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image.network(
            //   'https://www.mindinventory.com/blog/wp-content/uploads/2022/08/super-app-development.webp',
            //   width: 300,
            // ),
            SizedBox(height: 24),
            Text('SAMAY',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text('Super App',
                style: TextStyle(color: Colors.white, fontSize: 32)),
            SizedBox(height: 12),
            Text('Main hu Samay, mere Sath chalo.!',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontStyle: FontStyle.italic)),
            SizedBox(height: 8),
            Text('QuickJet Business Solution Private Limited',
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

class CompanyOverviewSlide extends StatelessWidget {
  final List<_Service> services = [
    _Service(FontAwesomeIcons.userMd, 'Doctors'),
    _Service(FontAwesomeIcons.spa, 'Salons & Spas'),
    _Service(FontAwesomeIcons.dumbbell, 'Gyms & Yoga'),
    _Service(FontAwesomeIcons.briefcase, 'Job Searches'),
    _Service(FontAwesomeIcons.paintBrush, 'Tattoo Artists'),
    _Service(FontAwesomeIcons.calendarCheck, 'Events'),
    _Service(FontAwesomeIcons.school, 'Schools'),
    _Service(FontAwesomeIcons.hotel, 'Hotels & Restaurants'),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(24),
      child: isWide
          ? Row(
              children: [
                Expanded(child: _overviewText()),
                SizedBox(width: 24),
                Expanded(child: _overviewImage()),
              ],
            )
          : Column(
              children: [
                _overviewText(),
                SizedBox(height: 16),
                _overviewImage(),
              ],
            ),
    );
  }

  Widget _overviewText() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Company Overview',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text(
            'Samay is a super app that simplifies booking appointments for various services, including:',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: services
                .map((s) => Chip(
                      avatar: FaIcon(s.icon, color: Color(0xFF2E6A50)),
                      label: Text(s.name),
                      backgroundColor: Colors.grey[200],
                    ))
                .toList(),
          ),
          SizedBox(height: 16),
          Text(
            'Additionally, Samay provides service providers with tools to manage appointments, calendars, sales, business reports, product sales, and job postings.',
            style: TextStyle(fontSize: 18),
          ),
        ],
      );

  Widget _overviewImage() => Image.network(
        'https://cdn.prod.website-files.com/66e2765d540e1939a89db4e3/66e2765d540e1939a89dc45a_5-features-all-super-apps-have-in-common-img3.webp',
      );
}

class ProblemBusinessSlide extends StatelessWidget {
  final List<_Problem> problems = [
    _Problem(FontAwesomeIcons.edit,
        'Many businesses still use pen and paper and Excel to manage appointments'),
    _Problem(FontAwesomeIcons.phone,
        'Traditional phone or WhatsApp scheduling with no public contact info'),
    _Problem(FontAwesomeIcons.chartBar,
        'No analysis of employee, sales, or customer data'),
    _Problem(FontAwesomeIcons.users, 'No centralized tracking of operations'),
    _Problem(
        FontAwesomeIcons.userTie, 'Difficulties hiring and sending promotions'),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Problem - For Businesses',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E6A50))),
          SizedBox(height: 24),
          isWide
              ? Row(
                  children: [
                    Expanded(
                        child: Image.network(
                            'https://media.excellentwebworld.com/wp-content/uploads/2024/09/19084648/Monolithic-Architecture-for-Super-App-Development.webp')),
                    SizedBox(width: 24),
                    Expanded(child: _problemList()),
                  ],
                )
              : Column(
                  children: [
                    Image.network(
                        'https://media.excellentwebworld.com/wp-content/uploads/2024/09/19084648/Monolithic-Architecture-for-Super-App-Development.webp'),
                    SizedBox(height: 16),
                    _problemList(),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _problemList() => Column(
        children: problems
            .map((p) => ListTile(
                  leading: FaIcon(p.icon, color: Color(0xFF2E6A50)),
                  title: Text(p.text, style: TextStyle(fontSize: 18)),
                ))
            .toList(),
      );
}

class SolutionPeopleSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    return Container(
      color: Color(0xFFF0F4F2),
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Text('Solution - For People',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E6A50))),
          SizedBox(height: 24),
          isWide
              ? Row(
                  children: [
                    Expanded(child: _solutionList()),
                    SizedBox(width: 24),
                    Expanded(
                        child: Image.network(
                            'https://miro.medium.com/v2/resize:fit:2000/1*1fOlBxCFPy55XpjP0_ujNQ.jpeg')),
                  ],
                )
              : Column(
                  children: [
                    _solutionList(),
                    SizedBox(height: 16),
                    Image.network(
                        'https://miro.medium.com/v2/resize:fit:2000/1*1fOlBxCFPy55XpjP0_ujNQ.jpeg'),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _solutionList() => Column(
        children: [
          _SolutionCard(
              icon: FontAwesomeIcons.mobileAlt,
              title: 'All-in-One Platform',
              description: 'Book and manage appointments all in one place.'),
          SizedBox(height: 16),
          _SolutionCard(
              icon: FontAwesomeIcons.clock,
              title: 'Effective Time Management',
              description:
                  'Save time and spend more quality time with family.'),
          SizedBox(height: 16),
          _SolutionCard(
              icon: FontAwesomeIcons.notesMedical,
              title: 'Medical History Analysis',
              description: 'Analyze medical history for better care.'),
        ],
      );
}

class _SolutionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  const _SolutionCard(
      {required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            FaIcon(icon, color: Color(0xFF2E6A50), size: 32),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(description, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF0F4F2),
      padding: EdgeInsets.all(24),
      child: Center(
        child: Card(
          color: Color(0xFF2E6A50),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Get in Touch',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 16),
                ContactRow(
                    icon: FontAwesomeIcons.phone,
                    text: '+91 7972391849',
                    link: 'tel:+917972391849'),
                SizedBox(height: 8),
                ContactRow(
                    icon: FontAwesomeIcons.envelope,
                    text: 'quickjet@samayind.com',
                    link: 'mailto:quickjet@samayind.com'),
                SizedBox(height: 8),
                ContactRow(
                    icon: FontAwesomeIcons.globe,
                    text: 'samayind.com',
                    link: 'https://samayind.com'),
                SizedBox(height: 8),
                ContactRow(
                    icon: FontAwesomeIcons.linkedin,
                    text: 'linkedin.com/company/samaystartup',
                    link: 'https://linkedin.com/company/samaystartup'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final String link;
  const ContactRow(
      {required this.icon, required this.text, required this.link});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (await canLaunch(link)) {
          await launch(link);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, color: Colors.white),
          SizedBox(width: 12),
          Text(text, style: TextStyle(color: Colors.white, fontSize: 18)),
        ],
      ),
    );
  }
}

class _Service {
  final IconData icon;
  final String name;
  const _Service(this.icon, this.name);
}

class _Problem {
  final IconData icon;
  final String text;
  const _Problem(this.icon, this.text);
}
