# 🌪️ Smart Disaster Management & Emergency Response System

A web-based Smart Disaster Management and Emergency Response System designed to help users monitor weather conditions, receive disaster alerts, request emergency assistance, find shelters, view live maps, and support disaster response through volunteers.

The system combines **Flask, MySQL, HTML, CSS, JavaScript, OpenWeather API and Machine Learning** to provide a smart and interactive disaster management platform.

---

## 🚀 Project Overview

Natural disasters such as cyclones, floods, storms and heavy rainfall can cause serious damage to people and property.

The main goal of this project is to provide a centralized system where users can:

- Monitor current weather conditions
- Check future weather forecasts
- Receive disaster alerts
- Send emergency SOS requests
- Find nearby shelters
- View disaster-related locations on a map
- Register as volunteers
- Manage their profiles
- Receive AI/ML-based disaster risk predictions

Administrators can manage users, volunteers, SOS requests, shelters and disaster alerts from the system.

---

# 🎯 Objectives

The main objectives of this project are:

1. Provide real-time weather information.
2. Provide weather forecasts for upcoming days.
3. Provide disaster-related alerts.
4. Allow users to send emergency SOS requests.
5. Help users find available shelters.
6. Provide live map functionality.
7. Manage disaster response volunteers.
8. Provide an AI/ML-based disaster risk prediction feature.
9. Automatically generate disaster alerts when high risk is detected.
10. Maintain disaster management data using MySQL.

---

# ✨ Main Features

## 👤 User Features

Users can:

- Register an account
- Login to the system
- View dashboard
- View current weather
- Search weather by city
- View 5-day weather forecast
- View AI disaster risk
- View disaster alerts
- Send emergency SOS requests
- View shelters
- View live map
- Register as a volunteer
- View profile
- Edit profile
- Change password

---

# 👨‍💼 Admin Features

Administrators can:

- Access admin dashboard
- View SOS requests
- Resolve SOS requests
- Manage volunteers
- Approve volunteers
- Reject volunteers
- Add disaster alerts
- Manage disaster-related information
- View registered users
- Monitor system activities

---

# 🚨 SOS Emergency System

The SOS system allows users to send emergency requests.

When a user sends an SOS request, the system stores:

- User ID
- Emergency message
- Location
- Status
- Created time

Default status:

```text
Pending

### 🌦️ Weather Information

The system uses the **OpenWeather API** to provide real-time weather information.

Users can:

- Search weather by city
- View current temperature
- View feels-like temperature
- View minimum and maximum temperature
- View humidity
- View atmospheric pressure
- View wind speed
- View wind direction
- View visibility
- View weather condition
- View weather icon
- View sunrise time
- View sunset time
- View last updated time

---

### 📅 5-Day Weather Forecast

The system also provides upcoming weather information using the OpenWeather forecast API.

Forecast information includes:

- Date
- Temperature
- Feels-like temperature
- Humidity
- Weather condition
- Weather icon
- Wind speed

---

### 🤖 AI Disaster Risk Prediction

The project includes a Machine Learning-based disaster risk prediction feature.

Real-time weather data is collected from the OpenWeather API and passed to the trained Machine Learning model.

The model uses:

- Temperature
- Humidity
- Wind Speed
- Rainfall
- Atmospheric Pressure

The model predicts:

```text
LOW
MEDIUM
HIGH