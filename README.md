# StringThing

StringThing is a lightweight library for encoding and decoding strings using various patterns.

## Installation

StringThing has no external dependencies, so it can be installed from source or directly from rubygems:

```sh
gem install "string_thing"
```

or via Gemfile:

```sh
gem "string_thing"
```

## Usage

StringThing provides an API for encoding and decoding strings. To use it, import the StringThing class and create a new instance with an array of patterns in the order you want to use them:

```ruby
require 'string_thing'

myString = 'This is my string'

# Create a new instance of StringThing with default pattern (['split-halves', 'reverse', 'shift', 'swap-case', 'rotate'])
myStringThing = StringThing.new

# Encode the string
encoded = myStringThing.encode(myString)

# Output the encoded string
puts encoded # "ZN!TJ!TJIuHOJSUT!"

# Decode the string
decoded = myStringThing.decode(encoded)

# Output the decoded string
puts decoded # "This is my string"
```

## Patterns

StringThing patterns currently support the following operations:

- `split-halves`: Splits the string into two halves and swaps them.
	- `Abcd12` => `d12Abc`
- `reverse`: Reverses the order of the characters in the string.
	- `Abcd12` => `21dcbA`
- `shift`: Shifts the characters in the string up by 1 in the ASCII table.
	- `Abcd12` => `Bcde23`
- `swap-case`: Swaps uppercase & lowercase characters in the string.
	- `Abcd12` => `aBCD12`
- `rotate`:  Shifts the string 1 position to the right.
	- `Abcd12` => `2Abcd1`

To use a specific pattern, pass it as an argument to the StringThing constructor:

```ruby
require 'string_thing'

myStringThing1 = StringThing.new(['split-halves', 'shift', 'reverse', 'shift', 'swap-case', 'rotate'])

# OR

stringThingPattern = ['split-halves', 'shift', 'reverse', 'shift', 'swap-case', 'rotate']
myStringThing2 = StringThing.new(stringThingPattern)
```

## Example: Encoding Passwords for Secure Storage

StringThing can be used to encode passwords before hashing them and storing them in a database, making it more difficult for an attacker to retrieve the original password even if they gain access to the database.

Here's an example of how to use StringThing to encode a password before hashing it with bcrypt when working with passwords in a database:

#### Create User:

```ruby
require 'bcrypt'
require 'string_thing'

stringThingPattern = ['split-halves', 'shift', 'reverse', 'shift', 'swap-case', 'rotate']

# Generate a salt for the bcrypt hash
salt = BCrypt::Engine.generate_salt

# The original password to be encoded and hashed
password = 'myPassword123'

# Encode the password using StringThing
encodedPassword = StringThing.new(stringThingPattern).encode(password)

# Hash the encoded password with bcrypt
hashedPassword = BCrypt::Engine.hash_secret(encodedPassword, salt, cost: 12)

# Add the hashed password to a user object for storage in a database
user = {
  'username' => 'johndoe',
  'email' => 'johndoe@example.com',
  'password' => hashedPassword,
  'salt' => salt,
  # other user data...
}

# Add the user object to the database
myDatabase.addUser(user)
```

#### Authenticate User:

```ruby
require 'bcrypt'
require 'string_thing'

stringThingPattern = ['split-halves', 'shift', 'reverse', 'shift', 'swap-case', 'rotate']

# Retrieve the user's hashed password and salt from the database
user = myDatabase.getUserByUsername('johndoe')
hashedPassword = user.password
salt = user.salt

# The password entered by the user attempting to log in
passwordAttempt = 'myPassword123'

# Encode the password attempt using StringThing
encodedPasswordAttempt = StringThing.new(stringThingPattern).encode(passwordAttempt)

# Hash the encoded password attempt with bcrypt
hashedPasswordAttempt = BCrypt::Engine.hash_secret(encodedPasswordAttempt, salt, cost: 12)

# Compare the hashed password attempt to the stored hashed password
if (hashedPasswordAttempt == hashedPassword)
  # Passwords match - login successful!
else
  # Passwords do not match - login failed
end
```
