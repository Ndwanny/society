class AppConstants {
  // App Info
  static const String appName = 'Society260';
  static const String tagline = 'A Safe Space In Motion';

  // Navigation Items
  static const List<Map<String, String>> navItems = [
    {'label': 'Home', 'route': '/'},
    {'label': 'Club260', 'route': '/club260'},
    {'label': 'Code260', 'route': '/code260'},
    {'label': 'Events', 'route': '/events'},
    {'label': 'Blog', 'route': '/blog'},
  ];

  // Membership Plans
  static const Map<String, dynamic> freePlan = {
    'name': 'Explorer',
    'price': 0,
    'currency': 'ZMW',
    'features': [
      'Access to Club260 feed',
      'Post text & images',
      'Join community discussions',
      'View public events',
      '1 free course per month',
    ],
  };

  static const Map<String, dynamic> proPlan = {
    'name': 'Member',
    'price': 150,
    'currency': 'ZMW',
    'period': 'month',
    'features': [
      'Everything in Explorer',
      'Unlimited course access',
      'Direct messaging',
      'Voice & video calls',
      'Exclusive member events',
      'Monthly Club260 virtual sessions',
      'Member-only content',
      'Priority support',
    ],
  };

  static const Map<String, dynamic> premiumPlan = {
    'name': 'Advocate',
    'price': 350,
    'currency': 'ZMW',
    'period': 'month',
    'features': [
      'Everything in Member',
      '1-on-1 coaching sessions',
      'Early access to all events',
      'Code260 educator toolkit',
      'Quarterly wellness packages',
      'Exclusive workshops',
      'Society260 merchandise discount',
      'Dedicated community space',
    ],
  };

  // Comic Issues
  static const List<Map<String, dynamic>> comicIssues = [
    {
      'issue': 1,
      'title': 'The Beginning',
      'description': 'CODE 260 begins here. Join Zara, Moni and Sol as they journey into the big, big world.',
      'pages': 4,
    },
    {
      'issue': 2,
      'title': 'Back to School',
      'description': 'Today\'s episode dives into the messy, colourful world of emotions.',
      'pages': 5,
    },
  ];

  // Characters
  static const List<Map<String, dynamic>> characters = [
    {
      'name': 'MONI',
      'age': 13,
      'tagline': '"Kind vibes only!"',
      'color': 0xFF6B9FD4,
      'description': 'The quiet storm of the crew. Deep on the inside, chill on the outside.',
      'style': 'Radiating warmth with her sweet, approachable style.',
      'struggle': 'Keeping the peace, but they\'ve got the magic touch.',
      'funFact': 'Their advice is like a hug wrapped in words.',
    },
    {
      'name': 'ZARA',
      'age': 13,
      'tagline': '"Stylish, smart, and always one step ahead!"',
      'color': 0xFFE87B6E,
      'description': 'Strong and totally unafraid to speak her truth.',
      'style': 'Think chic and tech-savvy — always accessorized with a book or gadget.',
      'struggle': 'Anxiously overthinks everything, but hey, it\'s because she cares!',
      'funFact': 'Her pep talks? Like TED Talks, but cooler.',
    },
    {
      'name': 'SOL',
      'age': 13,
      'tagline': '"Brains, creativity, and empathy in one teal package!"',
      'color': 0xFF7ECFC0,
      'description': 'Big dreams, bright mind, always thinking one step ahead.',
      'style': 'Rocking futuristic fits that look straight out of tomorrow.',
      'struggle': 'Navigates body dysmorphia with grace and courage.',
      'funFact': 'Her idea to form the Code Society260 club with her friends? Total genius move!',
    },
  ];

  // Admin Stats (mock)
  static const int totalUsers = 1247;
  static const int activeMembers = 389;
  static const int totalPosts = 5823;
  static const int totalEvents = 24;
}
