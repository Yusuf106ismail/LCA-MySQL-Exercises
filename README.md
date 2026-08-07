# LCA MySQL Exercises

## Repository Description
This repository contains a collection of SQL scripts and database projects completed for the **Life Choices Academy (LCA)** curriculum. It showcases practical application of database design principles, relational data modeling, normalisation (up to 3NF), constraint enforcement, and query writing using MySQL Workbench on port 3307.

---

## Included Exercises

### Exercise 01: EduTrack SA Relational Database System
* **File:** `week1_mysql_ex01_MogamedYusufIsmail.sql`
* **Description:** Design and implementation of a 3NF normalised relational database for **EduTrack SA**, a South African online learning platform based in Cape Town.

**Key Features:**
* Creates the `edutrack_sa` schema.
* Builds four core tables: `facilitators`, `courses`, `trainees`, and `enrolments`.
* Implements key constraints (`PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `NOT NULL`, and `AUTO_INCREMENT`).
* Includes stretch goals: status validation via `CHECK` constraints, auto-populating `TIMESTAMP` columns, and location-filtered reporting queries (`Gauteng` trainees).
* Populated with realistic South African regional entity data.

---

## Instructions for Execution
1. Open **MySQL Workbench** connected to your local server (Port `3307`).
2. Navigate to **File > Open SQL Script...** and select `week1_mysql_ex01_MogamedYusufIsmail.sql`.
3. Run the complete script using the **Execute / Lightning Bolt (⚡)** button.
