require_relative 'app'

def main
  app = App.new
  puts 'Welcome to School Library App!'
  loop do
    app.run
    option = gets.chomp.to_i
    if option === 7
      puts 'Thank you for using this app!'
      puts
      break      
    end
    app.option(option)
  end  
end

main
