# 🏦 IBMS - Internet Banking Management System

A secure, full-stack banking web application built with **Spring Boot**, **Spring Data JPA**, **Hibernate ORM**, **PostgreSQL**, and **JSP** views.

---

## 🛠️ Prerequisites
Before running this project, ensure you have the following installed on your machine:
1. **Java JDK 11+** → [Download](https://www.oracle.com/java/technologies/downloads/)
2. **PostgreSQL 14+** → [Download](https://www.postgresql.org/download/)
3. **Eclipse IDE** (with Spring Tools Suite or Enterprise edition), **IntelliJ IDEA**, or **VS Code**

---

## 🚀 Setup Instructions

### Step 1: Create the Database
1. Open **pgAdmin** and connect to your PostgreSQL server.
2. Right-click on **Databases** → **Create** → **Database**.
3. Name it `ibms1` and click **Save**.

### Step 2: Configure Database Credentials
1. Open [ibms/src/main/resources/application.properties](file:///c:/Users/aftab/Downloads/projectSend/ibms/src/main/resources/application.properties).
2. Update the PostgreSQL credentials to match your local setup:
   - `spring.datasource.url=jdbc:postgresql://localhost:5432/ibms1`
   - `spring.datasource.username=postgres`
   - `spring.datasource.password=your_postgresql_password`

### Step 3: Run the Application
You can run the application in two ways:

#### Option A: Run via Maven CLI (Recommended)
1. Open a terminal/command prompt at the `ibms` project root folder:
   ```bash
   cd ibms
   ```
2. Run the application using the Maven wrapper:
   - **On Windows:**
     ```bash
     mvnw.cmd spring-boot:run
     ```
   - **On macOS/Linux:**
     ```bash
     ./mvnw spring-boot:run
     ```

#### Option B: Run in Eclipse IDE
1. Open **Eclipse IDE**.
2. Go to **File** → **Import** → **Existing Maven Projects**.
3. Select the `ibms` folder as the root directory and click **Finish**.
4. Wait for Maven to build and download the required dependencies.
5. Locate the main class: `src/main/java/com/jsp/ibms/IbmsApplication.java`.
6. Right-click `IbmsApplication.java` → **Run As** → **Java Application** (or **Spring Boot App** if using STS).

Once started, the application will be active at: **`http://localhost:8082/`**

### Step 4: Run the SQL Setup Script
To set up essential stored procedures, triggers, audit logging tables, and views:
1. Ensure the application has been started at least once (which allows Hibernate to automatically create the base tables).
2. Open **pgAdmin** → Right-click `ibms1` → **Query Tool**.
3. Open and copy the contents of the setup script: [complete_setup.sql](file:///c:/Users/aftab/Downloads/projectSend/ibms/src/main/resources/sql/complete_setup.sql).
4. Paste the SQL query into the Query Tool and click **Execute (F5)**.

---

## 🔑 Login Credentials

| Role | Email | Password |
|------|-------|----------|
| **Admin** | `admin@ibms.com` | `admin123` |
| **User** | *(Register a new account via UI)* | *(Your chosen password)* |

---

## 📁 Project Structure
```
projectSend/
├── README.md                 ← Main project documentation
├── ibms/                     ← Spring Boot application root
│   ├── src/main/java/com/jsp/ibms/
│   │   ├── config/           ← Interceptors & Web configurations
│   │   ├── controller/       ← Spring MVC Controllers (handling UI navigation & endpoints)
│   │   ├── dao/              ← Direct Database Access Objects (stored procedure calls)
│   │   ├── entity/           ← Hibernate JPA entities (Users, Transactions, AuditLog, etc.)
│   │   ├── listener/         ← Seeders (e.g. Admin Seeder)
│   │   └── repository/       ← Spring Data JPA repositories (CRUD operations)
│   ├── src/main/resources/
│   │   ├── application.properties  ← DB URL, credentials, port configuration
│   │   └── sql/              ← Database triggers, stored procedures, and setup scripts
│   ├── src/main/webapp/      ← Web view contents
│   │   ├── css/              ← Global page styles
│   │   ├── admin/            ← Admin pages
│   │   ├── includes/         ← Reusable JSP fragments (header, sidebar, footer)
│   │   └── *.jsp             ← Client-facing JSP views
│   └── pom.xml               ← Project Maven configuration
```

---

## ✨ Key Features
- **User Dashboard:** View current balance, personal profile details, and interactive account summaries.
- **Fund Transfer:** Transfer funds securely via Account Number or Email. Utilizes database-level row locking (`FOR UPDATE`) in PostgreSQL stored procedures to guarantee transactional atomicity and prevent double-spending.
- **Transactions:** Deposit or withdraw funds with real-time balance calculations.
- **Bill Payment:** Pay utilities/bills directly from the account balance.
- **Beneficiary Management:** Add, list, or delete beneficiaries to easily repeat transfers.
- **Audit Logging & Triggers:** Automatic audit logs created by database triggers for every major database update, including negative balance prevention.
- **Security:** Session-based authentication, path authorization interceptors, and BCrypt password encryption.

---

## 🏗️ Technology Stack
- **Framework:** Spring Boot 2.7.18
- **Template Engine:** JSP (JavaServer Pages) & JSTL
- **Persistence Layer:** Spring Data JPA / Hibernate
- **Database:** PostgreSQL
- **Security:** Spring Security Crypto (BCrypt Encoder)
- **Build Tool:** Maven
