![Logo](/public/header_logo.png?raw=true)

### {{ [twitter](https://twitter.com/wreeto_official) ~ [reddit](https://www.reddit.com/r/wreeto/) }}

## Introduction

Wreeto is an open source note-taking, knowledge management and wiki system built on top of Ruby on Rails framework.  

Initially this was built because I didn't like the note-taking apps out there and I wanted something simple, structured and straightforward, with no bells and whistles.

### Current version: _v2.1.2_

## Table of Contents 
1. [Features](#features)
2. [Roadmap](#roadmap)
3. [Requirements](#requirements)
4. [Installation](#installation)
5. [Usage](#usage) 
6. [Screenshots](#screenshots) 
7. [License](#license) 
8. [Professional edition](#professional-edition)

## <a name="features"></a> 1. Features 

- Simple, minimal UI - _less is more_
- Create unlimited notes with Markdown format
- Unlimited Categories
- Unlimited Tags (**new!**)
- List notes by Category or SubCategory
- Favorite notes appear on the top of the notes list and sidebar
- Authentication, authorization 
- Google oAuth integration
- Search
- Share notes in public with a __secure__ link
- Zip and download notes in markdown format
- Responsive mobile web UI

## <a name="roadmap"></a> 2. Roadmap 

- Test everything, everywhere. More testing..
- Improve UI inconsistencies
- Upgrade to Rails v6
- Note Templates
- Ability to attach files (e.g. Documents)
- Encryption
- Different Levels of security access for users
- User access control
- Dark mode
- Export notes to PDF format
- Cloud backups
- Version tracking
- Move UI to ReactJS
- Mobile apps
- A lot more ..

## <a name="requirements"></a> 3. Requirements

- Docker (optional)
  
or 

- Ruby 2.6.6
- PostgreSQL 11
- Redis 5.0.7

## <a name="installation"></a> 4. Installation

### 4.1 Set up your environment 

Copy the `.env.development.local` to `.env`:

```
cp .env.development.local .env 
```

and set up your variables:

```
OAUTH_GOOGLE_ID=
OAUTH_GOOGLE_SECRET=
POSTGRES_HOST=postgres
POSTGRES_USER=wreeto_admin
POSTGRES_PASSWORD=wreeto_password
POSTGRES_DB=wreeto_dev
POSTGRES_PORT=5432
RACK_ENV=development
RAILS_ENV=development
RECAPTCHA_SITE_KEY=
RECAPTCHA_SECRET_KEY=
REDIS_HOST=redis
REDIS_PASSWORD=
SMTP_USERNAME=
SMTP_PASSWORD=
WREETO_HOST=localhost # your IP Address or domain 
WREETO_PORT=8383
```

### 4.2 Use docker

The easiest way to get started *now* is to use `docker-compose` and simply execute:

```
docker-compose up
```

If you decide to just copy the `docker-compose.yml` file in order to deploy it locally, you'll also need to create `.env` (instructions in 4.1) and `docker-entrypoint.sh`. Make sure to add execute permissions to it `sudo chmod +x docker-entrypoint.sh`. 

In order to initialize the database and load the default account, you'll need to run: 

```
docker-compose run app bundle exec rake db:drop db:migrate db:setup
``` 

### 4.3 Install locally 

You will need to setup postgres, ruby, redis and their appropriate dependencies necessary by your O/S and environment. 

As for every Rails project:
- `bundle install`
- `bundle exec rake db:drop db:migrate db:setup`
- `bundle exec rails s`

Do not forget to create the `.env` file. 

## <a name="usage"></a> 5. Usage

### 5.1 Default account 

The default credentials are: username `user@email.com` and password `password`.

### 5.2 Create a new account (rails console)

You can create another account from the Rails console by running `bundle exec rails console` or `docker-compose run app bundle exec rails console` and then

```
User.create!({firstname: 'John', lastname: 'Murdock', email: 'user@email.com', password: 'password', confirmed_at: DateTime.now})
```

by changing the values as you wish, then `exit`. 

### 5.3 Web UI

To access the web application with default settings (hostname/port) please go to

```
http://localhost:8383
```

## <a name="screenshots"></a> 6. Screenshots

#### Login
![Screenshot Running Command](/public/screenshots/scr_1.png?raw=true)

#### Notes Inventory
![Screenshot Running Command](/public/screenshots/scr_2.png?raw=true)

#### Private Note View
![Screenshot Running Command](/public/screenshots/scr_3.png?raw=true)

#### Public Note View
![Screenshot Running Command](/public/screenshots/scr_4.png?raw=true)

#### Category Items
![Screenshot Running Command](/public/screenshots/scr_5.png?raw=true)

#### Create a new Note 
![Screenshot Running Command](/public/screenshots/scr_6.png?raw=true)

#### Categories list
![Screenshot Running Command](/public/screenshots/scr_7.png?raw=true)

#### Wiki view
![Screenshot Running Command](/public/screenshots/scr_8.png?raw=true)

#### Search
![Screenshot Running Command](/public/screenshots/scr_9.png?raw=true)

## <a name="license"></a> 7. License

AGPLv3 License for the community version 

## <a name="professional-edition"></a> 8. Professional edition 

There is a professional version and there is a pricing plan for this edition. Please check https://wreeto.com for more details (currently updating).