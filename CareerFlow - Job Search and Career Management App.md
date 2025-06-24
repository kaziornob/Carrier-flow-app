# CareerFlow - Job Search and Career Management App

CareerFlow is a comprehensive Flutter mobile application designed to streamline the job search process and help users manage their career development. The app provides features for job discovery, application tracking, interview management, and professional skill development.

## Features

### 🔍 Job Search & Discovery
- Advanced job search with filters (location, job type, experience level, remote work)
- Real-time job recommendations based on user profile and skills
- Detailed job descriptions with company information and requirements
- Save jobs for later review and application

### 📋 Application Management
- Track all job applications in one centralized dashboard
- Monitor application status (Applied, Interview Scheduled, Offer Received, Rejected)
- Schedule and manage interviews with detailed notes
- Application analytics and insights

### 🎓 Learning & Career Development
- Curated articles on career development, interview tips, and industry trends
- Personalized learning resource recommendations
- Skill tracking and development suggestions
- Professional growth insights and tips

### 👤 User Profile & Authentication
- Secure user registration and authentication
- Comprehensive profile management with skills and experience
- Professional summary and contact information
- Privacy settings and data management

## Technology Stack

### Frontend (Mobile App)
- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Provider pattern
- **Navigation**: GoRouter
- **UI Components**: Material Design 3
- **Authentication**: JWT tokens
- **HTTP Client**: http package

### Backend (API Server)
- **Framework**: Flask (Python)
- **Database**: SQLite with SQLAlchemy ORM
- **Authentication**: JWT tokens
- **API Documentation**: RESTful endpoints
- **CORS**: Enabled for cross-origin requests

## Project Structure

```
career_flow/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/                   # Data models
│   │   ├── user.dart
│   │   ├── job.dart
│   │   ├── application.dart
│   │   └── learning.dart
│   ├── services/                 # API services
│   │   ├── auth_service.dart
│   │   ├── job_service.dart
│   │   ├── application_service.dart
│   │   └── learning_service.dart
│   ├── providers/                # State management
│   │   ├── auth_provider.dart
│   │   ├── job_provider.dart
│   │   ├── application_provider.dart
│   │   └── learning_provider.dart
│   ├── screens/                  # UI screens
│   │   ├── auth/
│   │   ├── job/
│   │   ├── application/
│   │   ├── learning/
│   │   └── profile/
│   ├── widgets/                  # Reusable UI components
│   └── utils/                    # Utility functions
├── pubspec.yaml                  # Flutter dependencies
└── README.md

career_flow_backend/
├── src/
│   ├── main.py                   # Flask app entry point
│   ├── models/
│   │   └── user.py              # Database models
│   ├── routes/                   # API endpoints
│   │   ├── auth.py
│   │   ├── jobs.py
│   │   ├── applications.py
│   │   └── learning.py
│   └── database/
│       └── app.db               # SQLite database
├── requirements.txt              # Python dependencies
└── README.md
```



## Installation and Setup

### Prerequisites

Before setting up CareerFlow, ensure you have the following installed:

- **Flutter SDK** (3.0 or higher)
- **Dart SDK** (included with Flutter)
- **Python** (3.8 or higher)
- **Git** for version control
- **Android Studio** or **VS Code** with Flutter extensions
- **Android SDK** for Android development
- **Xcode** for iOS development (macOS only)

### Backend Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd career_flow_backend
   ```

2. **Create and activate virtual environment**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install Python dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Initialize the database**
   ```bash
   python src/main.py
   ```
   The database will be automatically created on first run.

5. **Seed sample data**
   ```bash
   curl -X POST http://localhost:5000/api/jobs/seed
   ```

6. **Start the backend server**
   ```bash
   python src/main.py
   ```
   The server will run on `http://localhost:5000`

### Frontend Setup

1. **Navigate to Flutter project**
   ```bash
   cd career_flow
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Check Flutter setup**
   ```bash
   flutter doctor
   ```
   Resolve any issues reported by Flutter doctor.

4. **Update API base URL** (if needed)
   Edit the API base URL in the service files to match your backend server:
   ```dart
   static const String _baseUrl = 'http://localhost:5000'; // Update as needed
   ```

5. **Run the app**
   ```bash
   flutter run
   ```
   Choose your target device (Android emulator, iOS simulator, or physical device).

### Development Environment Setup

#### Android Development
1. Install Android Studio
2. Set up Android SDK and emulator
3. Enable USB debugging on physical devices

#### iOS Development (macOS only)
1. Install Xcode from App Store
2. Set up iOS Simulator
3. Configure development certificates for physical devices

#### VS Code Setup
1. Install Flutter and Dart extensions
2. Configure debug settings
3. Set up code formatting and linting

## Configuration

### Environment Variables

Create a `.env` file in the backend directory for environment-specific configurations:

```env
SECRET_KEY=your-secret-key-here
DATABASE_URL=sqlite:///app.db
JWT_SECRET=your-jwt-secret-here
DEBUG=True
```

### API Configuration

The Flutter app communicates with the backend through RESTful APIs. Update the base URL in service files if deploying to a different server:

```dart
// In lib/services/auth_service.dart and other service files
static const String _baseUrl = 'https://your-api-domain.com';
```

### Database Configuration

The app uses SQLite for development. For production, consider upgrading to PostgreSQL or MySQL:

```python
# In src/main.py
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://user:password@localhost/careerflow'
```


## API Documentation

The CareerFlow backend provides RESTful APIs for all app functionality. All endpoints return JSON responses.

### Authentication

All protected endpoints require a JWT token in the Authorization header:
```
Authorization: Bearer <jwt-token>
```

#### POST /api/auth/login
Login with email and password.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "token": "jwt-token-here",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "name": "John Doe",
    "phone": "+1234567890",
    "location": "San Francisco, CA",
    "professional_summary": "Software developer with 5 years experience",
    "skills": ["Flutter", "Python", "JavaScript"],
    "privacy_settings": {}
  }
}
```

#### POST /api/auth/register
Register a new user account.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123",
  "name": "John Doe"
}
```

#### POST /api/auth/forgot-password
Request password reset (demo endpoint).

**Request Body:**
```json
{
  "email": "user@example.com"
}
```

#### PUT /api/auth/profile
Update user profile (requires authentication).

**Request Body:**
```json
{
  "name": "John Doe",
  "phone": "+1234567890",
  "location": "San Francisco, CA",
  "professional_summary": "Updated summary",
  "skills": ["Flutter", "Python", "JavaScript", "React"]
}
```

### Jobs

#### GET /api/jobs/
Search and filter jobs.

**Query Parameters:**
- `search` - Search term for job title, company, or description
- `location` - Filter by location
- `job_type` - Filter by job type (full_time, part_time, contract, internship)
- `experience_level` - Filter by experience level (entry, mid, senior, executive)
- `is_remote` - Filter remote jobs (true/false)
- `page` - Page number for pagination (default: 1)
- `per_page` - Items per page (default: 20)

**Response:**
```json
{
  "jobs": [
    {
      "id": 1,
      "title": "Senior Flutter Developer",
      "company": "TechCorp Inc.",
      "location": "San Francisco, CA",
      "job_type": "full_time",
      "experience_level": "senior",
      "salary_min": 120000,
      "salary_max": 160000,
      "description": "Job description here...",
      "requirements": "Requirements here...",
      "benefits": "Benefits here...",
      "skills_required": ["Flutter", "Dart", "Mobile Development"],
      "posted_date": "2025-06-20T16:18:18.522554",
      "application_deadline": null,
      "is_remote": true,
      "company_logo_url": null
    }
  ],
  "total": 6,
  "pages": 1,
  "current_page": 1,
  "per_page": 20
}
```

#### GET /api/jobs/{job_id}
Get detailed information about a specific job.

#### POST /api/jobs/seed
Seed the database with sample jobs (development only).

### Applications

#### GET /api/applications/
Get all applications for the authenticated user.

**Response:**
```json
[
  {
    "id": 1,
    "user_id": 1,
    "job_id": 1,
    "status": "applied",
    "date_applied": "2025-06-20T16:18:18.522554",
    "notes": "Applied through company website",
    "resume_used": "resume_v2.pdf",
    "cover_letter_used": "cover_letter_tech.pdf",
    "job": {
      "id": 1,
      "title": "Senior Flutter Developer",
      "company": "TechCorp Inc."
    },
    "interviews": []
  }
]
```

#### POST /api/applications/
Create a new job application.

**Request Body:**
```json
{
  "job_id": 1,
  "notes": "Applied through company website",
  "resume_used": "resume_v2.pdf",
  "cover_letter_used": "cover_letter_tech.pdf"
}
```

#### PUT /api/applications/{application_id}
Update an existing application.

**Request Body:**
```json
{
  "status": "interview_scheduled",
  "notes": "Updated notes"
}
```

#### DELETE /api/applications/{application_id}
Delete an application.

#### POST /api/applications/{application_id}/interviews
Add an interview to an application.

**Request Body:**
```json
{
  "scheduled_date": "2025-06-25T14:00:00Z",
  "location": "Video call - Zoom",
  "interviewer_name": "Sarah Johnson",
  "notes": "Technical interview"
}
```

#### PUT /api/applications/interviews/{interview_id}
Update an interview.

#### GET /api/applications/check/{job_id}
Check if user has already applied to a job.

### Learning

#### GET /api/learning/articles
Get career development articles.

**Query Parameters:**
- `category` - Filter by article category

**Response:**
```json
[
  {
    "id": "article_1",
    "title": "How to Ace Your Next Technical Interview",
    "content": "Full article content...",
    "summary": "Essential tips and strategies for succeeding in technical interviews",
    "category": "Interview Tips",
    "published_date": "2025-06-20T16:18:26.331559",
    "image_url": "https://example.com/interview-tips.jpg",
    "author": "Sarah Johnson",
    "tags": ["interview", "technical", "career", "preparation"]
  }
]
```

#### GET /api/learning/resources
Get learning resources and courses.

**Query Parameters:**
- `skill` - Filter by skill
- `category` - Filter by resource category

**Response:**
```json
[
  {
    "id": "resource_1",
    "title": "Flutter Complete Course",
    "description": "Learn Flutter from scratch and build beautiful mobile apps",
    "url": "https://www.udemy.com/course/flutter-complete-course",
    "platform": "Udemy",
    "category": "Mobile Development",
    "skills": ["Flutter", "Dart", "Mobile Development"],
    "rating": 4.8,
    "is_free": false
  }
]
```

#### GET /api/learning/skills/recommended
Get recommended skills for career development.

**Query Parameters:**
- `user_skills` - Comma-separated list of current user skills

**Response:**
```json
["React Native", "Swift", "Kotlin", "JavaScript", "TypeScript"]
```


## Usage Guide

### Getting Started

1. **Register an Account**
   - Open the CareerFlow app
   - Tap "Sign Up" on the login screen
   - Enter your email, password, and full name
   - Complete your profile with skills and professional summary

2. **Complete Your Profile**
   - Navigate to the Profile tab
   - Add your phone number and location
   - Write a professional summary
   - Add your skills and experience

### Job Search

1. **Browse Jobs**
   - Use the Jobs tab to browse available positions
   - Apply filters to narrow down results:
     - Location (city, state, or "Remote")
     - Job type (Full-time, Part-time, Contract, Internship)
     - Experience level (Entry, Mid, Senior, Executive)
     - Remote work options

2. **Search Jobs**
   - Use the search bar to find specific roles
   - Search by job title, company name, or keywords
   - Combine search with filters for better results

3. **View Job Details**
   - Tap on any job card to view full details
   - Review job description, requirements, and benefits
   - Check salary range and company information
   - See required skills and qualifications

4. **Apply to Jobs**
   - Tap "Apply Now" on the job detail screen
   - Add application notes (optional)
   - Specify which resume and cover letter you used
   - Track your application in the Applications tab

### Application Management

1. **Track Applications**
   - View all applications in the Applications tab
   - Applications are organized by status:
     - Applied: Recently submitted applications
     - Interview: Applications with scheduled interviews
     - Offer: Applications with job offers
     - Rejected: Unsuccessful applications

2. **Update Application Status**
   - Tap the three-dot menu on any application card
   - Select the new status from the dropdown
   - Add notes about status changes

3. **Manage Interviews**
   - Schedule interviews from the application detail screen
   - Add interview details:
     - Date and time
     - Location (in-person or video call)
     - Interviewer name and contact
     - Preparation notes
   - Mark interviews as completed after they occur

4. **Application Notes**
   - Add detailed notes to each application
   - Track communication with recruiters
   - Record feedback from interviews
   - Note follow-up actions needed

### Learning and Development

1. **Read Career Articles**
   - Browse curated articles in the Learning tab
   - Filter articles by category:
     - Interview Tips
     - Career Development
     - Remote Work
     - Salary Negotiation
     - Technology Trends
   - Save articles for later reading

2. **Discover Learning Resources**
   - Explore courses and tutorials
   - Filter by skill or category
   - Find both free and paid resources
   - Access resources from platforms like:
     - Udemy
     - Coursera
     - freeCodeCamp
     - YouTube
     - AWS Training

3. **Skill Development**
   - View personalized skill recommendations
   - Track your current skills in your profile
   - Find learning resources for specific skills
   - Plan your professional development path

### Profile Management

1. **Update Personal Information**
   - Edit your name, phone, and location
   - Update your professional summary
   - Modify your skills list
   - Keep your profile current and accurate

2. **Privacy and Security**
   - Change your password in settings
   - Review privacy settings
   - Manage data sharing preferences
   - Log out securely when needed

## Features in Detail

### Advanced Job Filtering
- **Location-based Search**: Find jobs in specific cities or remote positions
- **Salary Range Filtering**: Set minimum and maximum salary expectations
- **Company Size**: Filter by startup, mid-size, or enterprise companies
- **Industry Focus**: Target specific industries or sectors

### Smart Application Tracking
- **Status Automation**: Automatically update status based on email integrations
- **Interview Reminders**: Get notifications for upcoming interviews
- **Follow-up Tracking**: Set reminders for application follow-ups
- **Analytics Dashboard**: View application success rates and trends

### Personalized Learning
- **Skill Gap Analysis**: Identify skills needed for target roles
- **Learning Path Recommendations**: Get structured learning plans
- **Progress Tracking**: Monitor your skill development over time
- **Industry Insights**: Stay updated with market trends and demands

### Professional Networking
- **Contact Management**: Store recruiter and contact information
- **Communication History**: Track all interactions with companies
- **Referral Tracking**: Manage job referrals and networking connections
- **Event Calendar**: Track job fairs, networking events, and deadlines

## Troubleshooting

### Common Issues

**App won't start or crashes**
- Ensure you have the latest version of Flutter
- Run `flutter clean` and `flutter pub get`
- Check device compatibility and available storage

**Login/Authentication issues**
- Verify email and password are correct
- Check internet connection
- Clear app cache and try again
- Reset password if needed

**Jobs not loading**
- Check internet connection
- Verify backend server is running
- Try refreshing the job list
- Check API endpoint configuration

**Application tracking not working**
- Ensure you're logged in
- Check if applications were created successfully
- Verify backend database connectivity
- Try logging out and back in

### Getting Help

- Check the GitHub repository for known issues
- Review API documentation for integration problems
- Contact support through the app's feedback feature
- Join the developer community for assistance

## Performance Optimization

### App Performance
- **Lazy Loading**: Jobs and articles load as needed
- **Image Caching**: Company logos and images are cached locally
- **Offline Support**: Basic functionality works without internet
- **Background Sync**: Data syncs when connection is restored

### Backend Performance
- **Database Indexing**: Optimized queries for fast job searches
- **Caching**: Frequently accessed data is cached
- **Pagination**: Large datasets are paginated for efficiency
- **Rate Limiting**: API endpoints are protected from abuse

## Security Features

### Data Protection
- **Encryption**: All data transmission is encrypted with HTTPS
- **JWT Tokens**: Secure authentication with expiring tokens
- **Password Hashing**: User passwords are securely hashed
- **Input Validation**: All user inputs are validated and sanitized

### Privacy Controls
- **Data Minimization**: Only necessary data is collected
- **User Control**: Users can delete their data anytime
- **Transparent Policies**: Clear privacy policy and terms of service
- **Secure Storage**: Local data is encrypted on device


## Deployment

### Backend Deployment

#### Using Flask Development Server
```bash
cd career_flow_backend
source venv/bin/activate
python src/main.py
```

#### Using Production WSGI Server
```bash
pip install gunicorn
gunicorn -w 4 -b 0.0.0.0:5000 src.main:app
```

#### Docker Deployment
```dockerfile
FROM python:3.9-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY src/ ./src/
EXPOSE 5000

CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "src.main:app"]
```

#### Environment Variables for Production
```env
SECRET_KEY=your-production-secret-key
DATABASE_URL=postgresql://user:password@localhost/careerflow_prod
JWT_SECRET=your-production-jwt-secret
DEBUG=False
CORS_ORIGINS=https://your-app-domain.com
```

### Mobile App Deployment

#### Android APK Build
```bash
flutter build apk --release
```

#### Android App Bundle (for Google Play Store)
```bash
flutter build appbundle --release
```

#### iOS Build (macOS only)
```bash
flutter build ios --release
```

#### Web Build
```bash
flutter build web --release
```

### Database Migration

For production deployment, consider migrating from SQLite to PostgreSQL:

1. **Install PostgreSQL dependencies**
   ```bash
   pip install psycopg2-binary
   ```

2. **Update database configuration**
   ```python
   app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://user:password@localhost/careerflow'
   ```

3. **Run migrations**
   ```bash
   flask db init
   flask db migrate -m "Initial migration"
   flask db upgrade
   ```

## Testing

### Backend Testing

Run the test suite to ensure API functionality:

```bash
cd career_flow_backend
source venv/bin/activate
python -m pytest tests/
```

### Frontend Testing

Run Flutter tests:

```bash
cd career_flow
flutter test
```

### Integration Testing

Test the complete app flow:

```bash
flutter drive --target=test_driver/app.dart
```

### API Testing with curl

Test authentication:
```bash
# Register a new user
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123","name":"Test User"}'

# Login
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'

# Get jobs (no auth required)
curl http://localhost:5000/api/jobs/

# Create application (requires auth token)
curl -X POST http://localhost:5000/api/applications/ \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{"job_id":1,"notes":"Test application"}'
```

## Contributing

We welcome contributions to CareerFlow! Here's how you can help:

### Development Setup

1. **Fork the repository**
2. **Clone your fork**
   ```bash
   git clone https://github.com/your-username/careerflow.git
   cd careerflow
   ```

3. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Set up development environment**
   - Follow the installation instructions above
   - Install development dependencies
   - Set up pre-commit hooks

### Code Style Guidelines

#### Flutter/Dart
- Follow the official [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format` to format code
- Run `flutter analyze` to check for issues
- Write meaningful variable and function names
- Add comments for complex logic

#### Python
- Follow [PEP 8](https://pep8.org/) style guidelines
- Use `black` for code formatting
- Use `flake8` for linting
- Write docstrings for functions and classes
- Add type hints where appropriate

### Submitting Changes

1. **Test your changes**
   - Run all tests and ensure they pass
   - Test the app manually on different devices
   - Verify API endpoints work correctly

2. **Commit your changes**
   ```bash
   git add .
   git commit -m "Add feature: your feature description"
   ```

3. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

4. **Create a Pull Request**
   - Provide a clear description of your changes
   - Include screenshots for UI changes
   - Reference any related issues

### Reporting Issues

When reporting bugs or requesting features:

1. **Check existing issues** to avoid duplicates
2. **Use issue templates** when available
3. **Provide detailed information**:
   - Steps to reproduce the issue
   - Expected vs actual behavior
   - Device and OS information
   - App version and build number
   - Screenshots or error logs

### Feature Requests

For new feature suggestions:

1. **Describe the problem** the feature would solve
2. **Explain the proposed solution** in detail
3. **Consider alternative approaches**
4. **Discuss implementation complexity**

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- **Flutter Team** for the excellent mobile development framework
- **Flask Community** for the lightweight and flexible web framework
- **Material Design** for the beautiful UI components and guidelines
- **Open Source Contributors** who make projects like this possible

## Support

For support and questions:

- **Documentation**: Check this README and inline code comments
- **Issues**: Report bugs and request features on GitHub
- **Community**: Join our developer community discussions
- **Email**: Contact the development team for urgent issues

## Roadmap

### Upcoming Features

- **Push Notifications**: Real-time updates for application status changes
- **Calendar Integration**: Sync interviews with device calendar
- **Resume Builder**: Built-in resume creation and editing tools
- **Company Reviews**: User-generated company reviews and ratings
- **Salary Insights**: Market salary data and negotiation tools
- **Video Interviews**: Integrated video calling for remote interviews
- **AI Recommendations**: Machine learning-powered job matching
- **Social Features**: Connect with other job seekers and professionals

### Long-term Goals

- **Multi-platform Support**: Web and desktop versions
- **Enterprise Features**: Company dashboard for recruiters
- **Advanced Analytics**: Detailed job market insights and trends
- **Integration Ecosystem**: Connect with LinkedIn, Indeed, and other platforms
- **Internationalization**: Support for multiple languages and regions
- **Accessibility**: Enhanced accessibility features for all users

---

**CareerFlow** - Streamlining your path to career success! 🚀

