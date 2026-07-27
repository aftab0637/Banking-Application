# 🏦 IBMS - Internet Banking Management System

A secure, full-stack banking web application built with Java Servlets, JSP, Hibernate ORM, and PostgreSQL.

## 🛠️ Prerequisites
Before running this project, install the following on your machine:
1. **Java JDK 8+** → [Download](https://www.oracle.com/java/technologies/downloads/)
2. **Apache Tomcat 9+** → [Download](https://tomcat.apache.org/download-90.cgi)
3. **PostgreSQL 14+** → [Download](https://www.postgresql.org/download/)
4. **Eclipse IDE (Enterprise Edition)** → [Download](https://www.eclipse.org/downloads/)

## 🚀 Setup Instructions

### Step 1: Create the Database
1. Open **pgAdmin** and connect to your PostgreSQL server.
2. Right-click on **Databases** → **Create** → **Database**.
3. Name it: `ibms1` and click **Save**.

### Step 2: Import the Project into Eclipse
1. Open **Eclipse IDE**.
2. Go to **File** → **Import** → **Existing Maven Projects**.
3. Browse to this project folder and click **Finish**.
4. Wait for Maven to download all dependencies.

### Step 3: Configure Database Connection
1. Open `src/main/resources/META-INF/persistence.xml`.
2. Update the PostgreSQL credentials if needed:
   - URL: `jdbc:postgresql://localhost:5432/ibms1`
   - Username: `postgres`
   - Password: *(your PostgreSQL password)*

### Step 4: Add Tomcat Server in Eclipse
1. Go to **Window** → **Show View** → **Servers**.
2. Click **"No servers available..."** link → Select **Apache Tomcat v9.0**.
3. Browse to your Tomcat installation directory → **Finish**.

### Step 5: Run the Application
1. Right-click the project → **Run As** → **Run on Server**.
2. Select your Tomcat server → **Finish**.
3. The app will open at: `http://localhost:8080/ibms/`

### Step 6: Run the SQL Setup Script
After the application starts once (so Hibernate creates the tables):
1. Open **pgAdmin** → Right-click `ibms1` → **Query Tool**.
2. Copy-paste the contents of `src/main/resources/sql/complete_setup.sql`.
3. Click **Execute (F5)**.

## 🔑 Login Credentials
| Role | Email | Password |
|------|-------|----------|
| Admin | admin@ibms.com | admin123 |
| User | *(Register a new account)* | *(Your password)* |

## 📁 Project Structure
```
ibms/
├── src/main/java/com/jsp/ibms/
│   ├── controller/       ← Servlets (MVC Controllers)
│   ├── entity/           ← Hibernate Entities (MVC Model)
│   ├── filter/           ← Security Filters
│   ├── listener/         ← Admin Seeder
│   └── util/             ← JPA Utility
├── src/main/resources/
│   ├── META-INF/         ← persistence.xml (DB config)
│   └── sql/              ← Stored Procedures, Views, Triggers
├── src/main/webapp/
│   ├── css/              ← Stylesheets
│   ├── includes/         ← Reusable JSP components
│   ├── admin/            ← Admin panel pages
│   └── *.jsp             ← User-facing pages (MVC Views)
└── pom.xml               ← Maven dependencies
```

## ✨ Key Features
- **User Module:** Register, Login, Dashboard, Fund Transfer (by Account No. / Email), Deposit, Withdraw, Bill Payment, Beneficiary Management, Transaction History
- **Admin Module:** Dashboard with statistics, User management, Audit logs
- **Security:** BCrypt password hashing, OTP verification, Session-based auth, Auth filters
- **Database:** PostgreSQL Stored Procedures, Triggers (audit log, negative balance prevention), Views

## 🏗️ Technology Stack
- **Frontend:** HTML5, CSS3, JSP
- **Backend:** Java Servlets
- **ORM:** Hibernate / JPA
- **Database:** PostgreSQL
- **Server:** Apache Tomcat 9
- **Build Tool:** Maven
