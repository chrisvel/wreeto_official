![Logo](/public/header_logo.png?raw=true)

## Introduction

Wreeto is an open source note-taking, knowledge management and wiki system built on Ruby on Rails framework.  
Initially this was built because I didn't like the note-taking apps out there and I wanted something simple, structured, with no bells and whistles.

### Current version

_v2.0.2_

## Features

- No more crappy UIs, _less is more_
- Create unlimited notes with Markdown format
- Unlimited Categories
- List notes by Category or SubCategory
- Favorite notes appear on the top of the notes list and sidebar
- Authentication, authorization 
- Google oAuth integration
- Search
- Share notes in public with a __secure__ link
- Zip and download notes in markdown format
- Responsive mobile web UI

## Roadmap

- Test everything, everywhere. More testing..
- Improve UI inconsistencies
- Upgrade to Rails v6
- Note Templates
- Ability to attach files (e.g. Documents)
- Encryption
- Different Levels of security access for users
- User access control
- Note Tags
- Dark mode
- Export notes to PDF format
- Cloud backups
- Version tracking
- Move UI to ReactJS
- Mobile apps
- A lot more ..

## Requirements

- Ruby
- PostgreSQL
- Redis
- Docker (optional)

## Installation

As for every Rails project:
- `bundle install`
- `bundle exec rake db:setup db:seed`

## Usage

The default credentials are: username `user@email.com` and password `password`.

You can create another account from the Rails console by running `rails console` or `docker-compose run app bundle exec rails c` and then
```
User.create!({firstname: 'John', lastname: 'Murdock', email: 'user@email.com', password: 'password', confirmed_at: DateTime.now})
```
by changing the values as you wish, then `exit`. 

## Docker

I've included a Dockerfile to run standalone and a docker-compose.yml file to add an external DB later. In order to build and run:

```
docker-compose build
docker-compose up
```

### Docker hub builds

https://hub.docker.com/r/chrisvel/wreeto

## Web UI

To access the web application please go to

```
http://localhost:8383
```

## Screenshots

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

## License

AGPLv3 License for the community version 

## Professional edition 

There is a professional version and there is a pricing plan for this edition. Please check https://wreeto.com 