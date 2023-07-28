require_relative 'student'
require_relative 'teacher'
require_relative 'book'
require_relative 'rental'

class App
  def initialize
    @books = []
    @rentals = []
    @people = []
  end

  def run
    puts 'Please choose an option by entering a number:'
    puts '1 - List all books'
    puts '2 - List all people'
    puts '3 - Create a person'
    puts '4 - Create a book'
    puts '5 - Create a rental'
    puts '6 - List all rentals for a given person id'
    puts '7 - Exit'
  end

  OPTIONS = {
    1 => :list_books,
    2 => :list_people,
    3 => :create_person,
    4 => :create_book,
    5 => :create_rental,
    6 => :list_rentals
  }.freeze

  def option(option)
    method_name = OPTIONS[option]
    if method_name
      send(method_name)
    else
      puts 'Invalid option, please type correct number!'
    end
  end

  def list_books
    @books.each_with_index do |book, index|
      puts "#{index}) Title: \"#{book.title}\", Author: #{book.author}"
    end
  end

  def list_people
    @people.each_with_index do |person, index|
      puts "#{index}) [#{person.class}] Name: #{person.name}, ID: #{person.id} Age: #{person.age}"
    end
  end

  def create_student
    puts
    print 'Age: '
    age = gets.chomp.strip.to_i

    while age < 4 || age > 120
      print 'Enter correct age: '
      age = gets.chomp.strip.to_i
    end

    print 'Name: '
    name = gets.chomp.strip.capitalize
    print 'Has parent permission? [Y/N]: '
    permission = gets.chomp.strip.upcase

    case permission
    when 'Y' || 'y'
      permission = true
    when 'N' || 'n'
      permission = false
    end

    @people << Student.new(age, nil, name, parent_permission: permission)
    puts 'Person created successfully'
    puts
  end

  def create_teacher
    puts
    print 'Age: '
    age = gets.chomp.strip.to_i
    while age < 18 || age > 120
      print 'Enter correct age: '
      age = gets.chomp.strip.to_i
    end
    print 'Name: '
    name = gets.chomp.strip.capitalize
    print 'Specialization: '
    specialization = gets.chomp.strip
    @people << Teacher.new(age, specialization, name)
    puts 'Person created successfully'
  end

  def create_person
    puts
    print 'Do you want to create a student (1) or a teacher (2)? [Input the number]: '
    option = gets.chomp.strip.to_i
    case option
    when 1
      create_student
    when 2
      create_teacher
    end
  end

  def get_person(id)
    @people.each do |person|
      return person if person.id == id
    end
    nil
  end

  def list_rentals
    print 'ID of person: '
    person_id = gets.chomp.to_i
    person = get_person(person_id)

    return unless person

    puts 'Rentals:'
    person.rentals.each do |rental|
      puts "Date: #{rental.date} Book: \"#{rental.book.title}\" by #{rental.book.author}"
    end
  end

  def create_book
    puts
    print 'Title: '
    title = gets.chomp.strip.capitalize
    print 'Author: '
    author = gets.chomp.strip.capitalize
    @books << Book.new(title, author)
    puts 'Book created successfully'
  end

  def create_rental
    puts
    puts 'Select a book from the following list by number'
    list_books
    book_option = gets.chomp.to_i

    while book_option.negative? || book_option >= @books.length
      print "Enter a number between 0 - #{@books.length - 1}: "
      book_option = gets.chomp.to_i
    end
    book = @books[book_option]

    puts
    puts 'Select a person from the following list by number (not id)'
    list_people
    person_option = gets.chomp.to_i

    while person_option.negative? || person_option >= @people.length
      print "Enter a number between 0 - #{@people.length - 1}: "
      person_option = gets.chomp.to_i
    end

    person = @people[person_option]

    puts
    print 'Date (YYYY/MM/DD): '
    date = gets.chomp.strip
    person.add_rental(date, book)
    puts 'Rental created successfully'
  end
end
