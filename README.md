# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
#Salary Management API

## Overview
A simple TDD-based Salary Management API that handles:
- Employee CRUD
- Salary calculation with TDS rules
- Country & Job-based salary metrics

## Stack
- Ruby on Rails (API mode)
- RSpec
- SQLite

## API Endpoints

 Endpoint 
 `/employees` | GET/POST | List / Create employee |
 `/employees/:id` | GET/PUT/DELETE | CRUD |
 `/employees/:id/calculate_salary` | GET | Calculate deductions & net salary |



## Example
GET /employees/1/calculate_salary
GET /employees/country_metrics 
GET /employees/job_title_metrics