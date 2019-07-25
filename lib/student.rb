class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new = self.new 
    new.id = row[0]
    new.name = row[1]
    new.grade = row[2]
    new
  end

  def self.all
    sql = <<-SQL
      SELECT * 
      FROM students 
    SQL
    
    all_students = []
    DB[:conn].execute(sql).each do |row|
      new = self.new_from_db(row)
      all_students << new
    end
    all_students
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * 
      FROM students 
      WHERE students.name = ?
      LIMIT 1
    SQL
 
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
  
  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT * 
      FROM students 
      WHERE students.grade = 9
    SQL
    
    grade_9 = []
    DB[:conn].execute(sql).each do |row|
      new = self.new_from_db(row)
      grade_9 << new
    end
  end 
  
  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * 
      FROM students 
      WHERE students.grade < 12
    SQL
    
    below_12 = []
    DB[:conn].execute(sql).each do |row|
      new = self.new_from_db(row)
      below_12 << new
    end
    below_12
  end 
  
  def self.first_X_students_in_grade_10(num) 
     sql = <<-SQL
      SELECT * 
      FROM students 
      WHERE students.grade = 10 
      LIMIT ?
    SQL
    
    x_in_grade_10 = []
    DB[:conn].execute(sql, num).each do |row|
      new = self.new_from_db(row)
      x_in_grade_10 << new
    end
    x_in_grade_10
  end 
  
  def self.first_student_in_grade_10
   sql = <<-SQL
      SELECT * 
      FROM students 
      WHERE students.grade = 10
      ORDER BY id
      LIMIT 1
    SQL
    
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first
  end 
  
  def self.all_students_in_grade_X(num)
    sql = <<-SQL
      SELECT * 
      FROM students 
      WHERE students.grade = ?
    SQL
    
    all_in_grade_x = []
    DB[:conn].execute(sql, num).each do |row|
      new = self.new_from_db(row)
      all_in_grade_x << new
    end
    all_in_grade_x
  end 
  
end
