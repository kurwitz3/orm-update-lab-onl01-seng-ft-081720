require_relative "../config/environment.rb"

class Student
 attr_accessor :name, :grade
 attr_reader :id 
 
 def initialize(id=nil,name, grade)
   @name = name 
   @grade = grade 
   @id = id 

end 

 def self.create_table 
   sql = <<-SQL
   CREATE TABLE IF NOT EXISTS students (
   id INTEGER PRIMARY KEY,
   name TEXT,
   grade TEXT)
    SQL
    DB[:conn].execute(sql)
   
end 
  def self.drop_table 
    sql = <<-SQL
    DROP TABLE students
    SQL
   DB[:conn].execute(sql)
 end
 
 def save 
   sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?, ?)
   SQL
 
   DB[:conn].execute(sql,self.name, self.grade)
 
   @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
 end
 
 def self.create(name,grade) 
   new = self.new(name, grade)
   new.save
   new
 end
 
 def self.find_by_name(name)
   sql = <<-SQL
   SELECT * FROM students WHERE name = ? LIMIT 1 
   SQL
  DB[:conn].execute(sql, name).map do |row|
     self.new_from_db(row)
   
 end.first
end

 def self.new_from_db(array)
   id = array[0]
   name = array[1]
   grade = array[2]
   self.new(id, name, grade)
  
 end
 
 
  def update
    sql = "UPDATE songs SET name = ?, album = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.album, self.id)
 
 end 
end
  
  
 
  
  
  
  
