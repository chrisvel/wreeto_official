![Logo](/public/header_logo.png?raw=true)

### {{ [twitter](https://twitter.com/wreeto_official) ~ [reddit](https://www.reddit.com/r/wreeto/) }}

## WARNING! 
_v3 is not compatible with v2, you will have to export your notes in v2 and import them in v3._
_This happens because v3 is almost a re-write of v2._

## Introduction

Wreeto is an open source note-taking, knowledge management and wiki system built on top of Ruby on Rails framework.  

Initially this was built because I didn't like the note-taking apps out there and I wanted something simple, structured and straightforward, with no bells and whistles.

### Current stable version: _v2.6.8_
### Latest version: _master_ or _v3.0.1.beta_

## Table of Contents 
1. [Features](#features)
2. [Roadmap](#roadmap)
3. [Requirements](#requirements)
4. [Installation](#installation)
5. [Usage](#usage) 
6. [How can you help](#how-can-you-help)
7. [Screenshots](#screenshots) 
8. [License](#license) 
9. [Professional edition](#professional-edition)

## <a name="features"></a> 1. Features 

- Simple, minimal UI - _less is more_
- Create unlimited notes with Markdown format
- Categories
- Tags 
- Projects 
- Attachments 
- Backlinks (**new!**)
- Graph view (**new!**)
- Encrypted backups
- List notes by Category or SubCategory
- Favorite notes appear on the top of the notes list and sidebar
- Authentication, authorization 
- Google oAuth integration
- Search
- Share notes in public with a __secure__ link
- Zip and download notes in markdown format
- Import notes from external, zipped, text-only files
- Responsive mobile web UI

## <a name="roadmap"></a> 2. Roadmap 

- Test everything, everywhere. More testing..
- Note Templates
- Encryption
- Different Levels of security access for users
- User access control
- Dark mode
- Quick notes that auto-expire 
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
POSTGRES_DB=wreeto_db
POSTGRES_PORT=5432
RACK_ENV=production
RAILS_ENV=production
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

For running the latest version (might be unstable) use `image: chrisvel/wreeto:master`. Instead use the latest stable version as (example) `image: chrisvel/wreeto:version-`.

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

The default credentials are: username `admin` and password `password`.

### 5.2 Create a new account (rails console)

You can create another account from the Rails console by running `bundle exec rails console` or `docker-compose run app bundle exec rails console` and then

```
account = Account.create!
User.create!({username: 'admin', email: 'user@email.com', password: 'password', confirmed_at: DateTime.now, account: account})
```

by changing the values as you wish, then `exit`. 

### 5.3 Web UI

To access the web application with default settings (hostname/port) please go to

```
http://localhost:8383
```

## <a name="how-can-you-help"></a> 6. How can you help

There are several ways you can help with wreeto:  

1. Try **wreeto** and send your feedback, comments or suggestions.
2. Clone the repo, develo and create a _Pull Request_
3. Spread the word about **wreeto** to your friends and your community. This is the way the project breaths and grows.  
4. Sponsor me through Github sponsors or donate to **Paypal:** [paypal.me/wreeto](https://paypal.me/wreeto)

## <a name="screenshots"></a> 7. Screenshots

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

## <a name="license"></a> 8. License

AGPLv3 License for the community version 

## <a name="professional-edition"></a> 9. Premium edition 

There is a premium version and there is a pricing plan for this edition. Please check https://wreeto.com or email to <wreeto.official and gmail as the domain provider> for more details (currently updating).
