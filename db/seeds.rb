# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

Organisation.create!(
  name: 'Legal Innovation Lab Wales'
)

Organisation.create!(
  name: 'Hogwarts'
)

## Create users
# Create Static Users
user = User.new(
  first_name: 'Phil',
  last_name: 'Reynolds',
  email: 'philr@purpleriver.dev',
  bio: 'Hello World',
  organisation_id: 1,
  admin: true,
  approved: true,
  terms: true,
  password: 'test1234'
)
user.skip_confirmation!
user.save!

user = User.new(
  first_name: 'Alex',
  last_name: 'Wing',
  email: 'a.j.wing@swansea.ac.uk',
  bio: 'Hello World',
  organisation_id: 1,
  admin: true,
  approved: true,
  terms: true,
  password: 'test1234'
)
user.skip_confirmation!
user.save!

user = User.new(
  first_name: 'Ieuan',
  last_name: 'Skinner',
  email: 'ieuan.skinner@swansea.ac.uk',
  bio: 'Hello World',
  organisation_id: 1,
  admin: true,
  approved: true,
  terms: true,
  password: 'test1234'
)
user.skip_confirmation!
user.save!

user = User.new(
  first_name: 'Demo',
  last_name: 'Not-Admin',
  email: 'sp-demo-noadmin@purpleriver.dev',
  bio: 'Hello World',
  organisation_id: 1,
  approved: true,
  terms: true,
  password: 'test1234'
)
user.skip_confirmation!
user.save!

user = User.new(
  first_name: 'Demo',
  last_name: 'Admin',
  email: 'sp-demo-admin@purpleriver.dev',
  bio: 'Hello World',
  organisation_id: 1,
  approved: true,
  admin: true,
  terms: true,
  password: 'test1234'
)
user.skip_confirmation!
user.save!


user = User.new(
  first_name: 'Harry',
  last_name: 'Potter',
  email: 'harrypotter@gmail.com',
  bio: 'The Chosen One',
  organisation_id: 2,
  admin: true,
  approved: true,
  terms: true,
  password: 'test1234'
)
user.skip_confirmation!
user.save!

user = User.new(
  first_name: 'Hermione',
  last_name: 'Granger',
  email: 'hermionegranger@gmail.com',
  bio: 'LeviOsa not levioSA',
  organisation_id: 2,
  admin: true,
  approved: true,
  terms: true,
  password: 'test1234'
)
user.skip_confirmation!
user.save!

user = User.new(
  first_name: 'Ron',
  last_name: 'Weasley',
  email: 'ronweasley@gmail.com',
  bio: 'Gryffindor Til I Die',
  organisation_id: 2,
  admin: false,
  approved: true,
  terms: true,
  password: 'test1234'
)
user.skip_confirmation!
user.save!

## Create example scenarios
# First Scenario

Scenario.create!(
  user_id: 1,
  variables: ['health', 'stamina', 'experience', 'coin'],
  variable_initial_values: [100, 100, 0, 10],
  variables_with_initial_values: { health: 100, stamina: 100, experience: 0, coin: 10 },
  name: 'First test adventure scenario',
  description: 'This is the first adventure scenario, it probably won\'t make a huge amount of sense but should have clickable options',
  available: true
)

# ID 1
Question.create!(
  user_id: 1,
  scenario_id: 1,
  order: 0,
  description: 'Welcome to your adventure, this is the first question',
  text: 'What direction would you like to go?'
)

# ID 2
Question.create!(
  user_id: 1,
  scenario_id: 1,
  order: 1,
  description: 'You went to the North. Its cold up here, and you meet a polar bear.',
  text: 'What do you do?'
)

# ID 3
Question.create!(
  user_id: 1,
  scenario_id: 1,
  order: 2,
  description: 'You went to the East. You don\'t speak the language here. You meet some locals.',
  text: 'What do you do?'
)

# ID 4
Question.create!(
  user_id: 1,
  scenario_id: 1,
  order: 3,
  description: 'You went to the West. You\'re on a boat. The Horizon is endless.',
  text: 'Which Direction do you go?'
)

# ID 5
Question.create!(
  user_id: 1,
  scenario_id: 1,
  order: 4,
  description: 'You lost all your health. You are dead.',
  text: 'View your scores.'
)

# ID 6
Question.create!(
  user_id: 1,
  scenario_id: 1,
  order: 5,
  description: 'You lost all your Stamina. The Bear catches you.',
  text: 'What happens next?'
)

# ID 7
Question.create!(
  user_id: 1,
  scenario_id: 1,
  order: 6,
  description: 'The bear takes pity of your and treats you like one of its cubs. This is your life now',
  text: 'View your Scores.'
)

# ID 8
Question.create!(
  user_id: 1,
  scenario_id: 1,
  order: 7,
  description: 'This doesn\'t work, this never works. They lock you in a cage where you slowly starve.',
  text: 'View your Scores.'
)

# ID 9
Question.create!(
  user_id: 1,
  scenario_id: 1,
  order: 8,
  description: 'The locals like your offering, they shower you with gold and make you their king.',
  text: 'View your Scores.'
)

# ID 10
Question.create!(
  user_id: 1,
  scenario_id: 1,
  order: 9,
  description: 'The locals accept your surrender and adopt you into your society as a cleaner. This is your life now.',
  text: 'View your Scores.'
)

# Question 1 Answers
Answer.create!(
  user_id: 1,
  question_id: 1,
  text: 'North',
  variable_mods: { health: 0, stamina: 0, experience: 0, coin: 0 },
  next_question_order: 1
)

Answer.create!(
  user_id: 1,
  question_id: 1,
  text: 'East',
  variable_mods: { health: 0, stamina: 0, experience: 0, coin: 0 },
  next_question_order: 2
)

Answer.create!(
  user_id: 1,
  question_id: 1,
  text: 'West',
  variable_mods: { health: 0, stamina: 0, experience: 0, coin: 0 },
  next_question_order: 3
)

# Question 2 Answers
Answer.create!(
  user_id: 1,
  question_id: 2,
  text: 'Fight the bear',
  variable_mods: { health: -100, stamina: -100, experience: 0, coin: 0 },
  next_question_order: 4
)

Answer.create!(
  user_id: 1,
  question_id: 2,
  text: 'Run away from the bear',
  variable_mods: { health: 0, stamina: -100, experience: 10, coin: 0 },
  next_question_order: 5
)

Answer.create!(
  user_id: 1,
  question_id: 2,
  text: 'Befriend the bear',
  variable_mods: { health: 0, stamina: 0, experience: 50, coin: 0 },
  next_question_order: 6
)

# Question 3 Answers
Answer.create!(
  user_id: 1,
  question_id: 3,
  text: 'Talk loudly and slowly in English',
  variable_mods: { health: -100, stamina: 0, experience: 0, coin: -10 },
  next_question_order: 7
)

Answer.create!(
  user_id: 1,
  question_id: 3,
  text: 'Barter',
  variable_mods: { health: 0, stamina: 0, experience: 100, coin: 100000000 },
  next_question_order: 8
)

Answer.create!(
  user_id: 1,
  question_id: 3,
  text: 'Surrender',
  variable_mods: { health: 0, stamina: 0, experience: 50, coin: 0 },
  next_question_order: 9
)

# Question 4 Answers
Answer.create!(
  user_id: 1,
  question_id: 4,
  text: 'The wind dies down. The horizon is flat. You can\'t go anywhere. You slowly run out of resources. ',
  variable_mods: { health: -100, stamina: 0, experience: 0, coin: 0 },
  next_question_order: 4
)

# Question 5 Answers
Answer.create!(
  user_id: 1,
  question_id: 5,
  text: 'How did I do?',
  variable_mods: { health: 0, stamina: 0, experience: 0, coin: 0 },
  next_question_order: -1
)

# Question 6 Answers
Answer.create!(
  user_id: 1,
  question_id: 6,
  text: 'The bear mauls you.',
  variable_mods: { health: -100, stamina: 0, experience: 0, coin: 0 },
  next_question_order: 4
)

# Question 7 Answers
Answer.create!(
  user_id: 1,
  question_id: 7,
  text: 'How did I do?',
  variable_mods: { health: 0, stamina: 0, experience: 0, coin: 0 },
  next_question_order: -1
)

# Question 8 Answers
Answer.create!(
  user_id: 1,
  question_id: 8,
  text: 'How did I do?',
  variable_mods: { health: 0, stamina: 0, experience: 0, coin: 0 },
  next_question_order: -1
)

# Question 9 Answers
Answer.create!(
  user_id: 1,
  question_id: 9,
  text: 'How did I do?',
  variable_mods: { health: 0, stamina: 0, experience: 0, coin: 0 },
  next_question_order: -1
)

# Question 10 Answers
Answer.create!(
  user_id: 1,
  question_id: 10,
  text: 'How did I do?',
  variable_mods: { health: 0, stamina: 0, experience: 0, coin: 0 },
  next_question_order: -1
)

# Second Scenario
Scenario.create!(
  user_id: 1,
  variables: ['knowledge', 'helpfulness', 'compassion', 'detail'],
  variable_initial_values: [0, 0, 0, 0],
  variables_with_initial_values: { knowledge: 0, helpfulness: 0, compassion: 0, detail: 0 },
  name: 'Scenario on retail secret shoppers',
  description: 'This is the scenario to test employees through online secret shoppers',
  available: false
)
# ID 11
Question.create!(
  user_id: 1,
  scenario_id: 2,
  order: 0,
  description: 'The customer walks into the store and browses around the counters, what do you do?',
  text: 'What do you do?'
)
# ID 12
Question.create!(
  user_id: 1,
  scenario_id: 2,
  order: 1,
  description: 'The customer speaks up and says "Why thank you, I\'m looking for this specific series item, do you keep it in stock?',
  text: 'What do you do?'
)
# ID 13
Question.create!(
  user_id: 1,
  scenario_id: 2,
  order: 2,
  description: 'The customer speaks up and says "uh.. hello?, I\'m looking for this specific series item, do you keep it in stock?',
  text: 'What do you do?'
)
# ID 14
Question.create!(
  user_id: 1,
  scenario_id: 2,
  order: 3,
  description: 'The customer lets out an annoyed sigh and tries to wave for your attention "Hello, I\'m looking for a series item, do you have it?"',
  text: 'What do you do?'
)
# ID 15
Question.create!(
  user_id: 1,
  scenario_id: 2,
  order: 4,
  description: 'The customer shakes their head "Is this all you can do?"',
  text: 'what do you do?'
)
# ID 16
Question.create!(
  user_id: 1,
  scenario_id: 2,
  order: 5,
  description: 'The customer smiles back and seems pleased with your reply, taking down their email and walks out satisfied',
  text: 'view your score'
)
# ID 17
Question.create!(
  user_id: 1,
  scenario_id: 2,
  order: 6,
  description: 'The customer smiles back but lets out a little annoyed sign as they leave, that could have been a sale',
  text: 'view your score'
)
# ID 18
Question.create!(
  user_id: 1,
  scenario_id: 2,
  order: 7,
  description: 'The customer demands your name',
  text: 'what do you do?'
)
# ID 19
Question.create!(
  user_id: 1,
  scenario_id: 2,
  order: 8,
  description: 'The customer storms out',
  text: 'view your score'
)

Answer.create!(
  user_id: 1,
  question_id: 11,
  text: 'Wait patiently until they approach',
  variable_mods: { knowledge: 0, helpfulness: 0, compassion: 0, detail: 0 },
  next_question_order: 2
)
Answer.create!(
  user_id: 1,
  question_id: 11,
  text: 'finish your current task and ignore the customer',
  variable_mods: { knowledge: 0, helpfulness: -2, compassion: -1, detail: 0 },
  next_question_order: 3
)
Answer.create!(
  user_id: 1,
  question_id: 11,
  text: 'Approach the customer with a compliment and a hello',
  variable_mods: { knowledge: 0, helpfulness: 0, compassion: 2, detail: 0 },
  next_question_order: 1
)
Answer.create!(
  user_id: 1,
  question_id: 11,
  text: 'You know it isn\'t in stock so you reply "sorry, we don\'t stock that item"',
  variable_mods: { knowledge: 0, helpfulness: -2, compassion: 0, detail: 0 },
  next_question_order: 4
)
Answer.create!(
  user_id: 1,
  question_id: 11,
  text: 'You know it isn\'t in stock but you offer some stores nearby',
  variable_mods: { knowledge: 0, helpfulness: 1, compassion: -1, detail: 0 },
  next_question_order: 6
)
Answer.create!(
  user_id: 1,
  question_id: 11,
  text: 'You know it isn\'t in stock but you offer a apologise, and an offer to call when it next comes in stock',
  variable_mods: { knowledge: 0, helpfulness: 0, compassion: 2, detail: 0 },
  next_question_order: 5
)
Answer.create!(
  user_id: 1,
  question_id: 11,
  text: '"sorry, but that\'s not much I can do"',
  variable_mods: { knowledge: 0, helpfulness: -2, compassion: -1, detail: 0 },
  next_question_order: 7
)
Answer.create!(
  user_id: 1,
  question_id: 11,
  text: 'You offer some apologies and offer some similar products in stock',
  variable_mods: { knowledge: 2, helpfulness: 1, compassion: 0, detail: 0 },
  next_question_order: 6
)
Answer.create!(
  user_id: 1,
  question_id: 11,
  text: 'You shrug your shoulders and reply "Not much I can do if it isn\'t here"',
  variable_mods: { knowledge: 0, helpfulness: -2, compassion: -2, detail: 0 },
  next_question_order: 7
)
Answer.create!(
  user_id: 1,
  question_id: 11,
  text: 'You refuse to give it "I don\'t have to do that"',
  variable_mods: { knowledge: 0, helpfulness: -2, compassion: -2, detail: 0 },
  next_question_order: 8
)
Answer.create!(
  user_id: 1,
  question_id: 11,
  text: 'You apologise and offer some resolution of similar products and some details of when next stock comes in"',
  variable_mods: { knowledge: 1, helpfulness: 1, compassion: 1, detail: 0 },
  next_question_order: 8
)
Answer.create!(
  user_id: 1,
  question_id: 11,
  text: 'You offer your name',
  variable_mods: { knowledge: 0, helpfulness: 0, compassion: 0, detail: 0 },
  next_question_order: 8
)

Attempt.create!(
  user_id: 1,
  scenario_id: 1,
  attempt_number: 1,
  question_answers:
    [{
      "question_id": 1,
      "answer_id": 1
    }, {
      "question_id": 2,
      "answer_id": 4
    }, {
      "question_id": 5,
      "answer_id": 11
    }],
  scores: { health: 0, stamina: 0, experience: 0, coin: 10 }
)
Attempt.create!(
  user_id: 1,
  scenario_id: 1,
  attempt_number: 2,
  question_answers:
    [{
      "question_id": 1,
      "answer_id": 1
    }, {
      "question_id": 2,
      "answer_id": 6
    }, {
      "question_id": 7,
      "answer_id": 13
    }],
  scores: { health: 100, stamina: 100, experience: 50, coin: 10 }
)
Attempt.create!(
  user_id: 1,
  scenario_id: 1,
  attempt_number: 3,
  question_answers:
    [{
      "question_id": 1,
      "answer_id": 2
    }, {
      "question_id": 3,
      "answer_id": 7
    }, {
      "question_id": 8,
      "answer_id": 14
    }],
  scores: { health: 0, stamina: 100, experience: 0, coin: 0 }
)
Attempt.create!(
  user_id: 1,
  scenario_id: 1,
  attempt_number: 4,
  question_answers:
    [{
      "question_id": 1,
      "answer_id": 2
    }, {
      "question_id": 3,
      "answer_id": 8
    }, {
      "question_id": 9,
      "answer_id": 15
    }],
  scores: { health: 100, stamina: 100, experience: 100, coin: 100000010 }
)
Attempt.create!(
  user_id: 2,
  scenario_id: 1,
  attempt_number: 1,
  question_answers:
    [{
      "question_id": 1,
      "answer_id": 2
    }, {
      "question_id": 3,
      "answer_id": 7
    }, {
      "question_id": 8,
      "answer_id": 14
    }],
  scores: { health: 0, stamina: 100, experience: 0, coin: 0 }
)
Attempt.create!(
  user_id: 3,
  scenario_id: 1,
  attempt_number: 1,
  question_answers:
    [{
      "question_id": 1,
      "answer_id": 2
    }, {
      "question_id": 3,
      "answer_id": 7
    }, {
      "question_id": 8,
      "answer_id": 14
    }],
  scores: { health: 0, stamina: 100, experience: 0, coin: 0 }
)
Attempt.create!(
  user_id: 3,
  scenario_id: 1,
  attempt_number: 2,
  question_answers:
    [{
      "question_id": 1,
      "answer_id": 2
    }, {
      "question_id": 3,
      "answer_id": 7
    }, {
      "question_id": 8,
      "answer_id": 14
    }],
  scores: { health: 0, stamina: 100, experience: 0, coin: 0 }
)
Attempt.create!(
  user_id: 3,
  scenario_id: 1,
  attempt_number: 3,
  question_answers:
    [{
      "question_id": 1,
      "answer_id": 2
    }, {
      "question_id": 3,
      "answer_id": 7
    }, {
      "question_id": 8,
      "answer_id": 14
    }],
  scores: { health: 0, stamina: 100, experience: 0, coin: 0 }
)


