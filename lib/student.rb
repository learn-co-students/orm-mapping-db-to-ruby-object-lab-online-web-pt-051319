class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    self.new().tap{ |student| student.name = row[1]; student.grade = row[2]; student.id = row[0]}
  end

  def self.all
    rows = DB[:conn].execute('SELECT * FROM students')
    rows.map{ |row| self.new_from_db(row) }
  end

  def self.find_by_name(name)
    row = DB[:conn].execute('SELECT * FROM students WHERE name = ?', name)[0]
    self.new_from_db(row)
  end

  def self.all_students_in_grade_9
    self.all_students_in_grade_X(9)
  end

  def self.students_below_12th_grade
    rows = DB[:conn].execute('SELECT * FROM students WHERE grade < 12')
    rows.map{ |row| self.new_from_db(row) }
  end

  def self.first_X_students_in_grade_10(x)
    rows = DB[:conn].execute('SELECT * FROM students WHERE grade = 10 LIMIT ?', x)
    rows.map{ |row| self.new_from_db(row) }
  end

  def self.first_student_in_grade_10
    self.first_X_students_in_grade_10(1)[0]
  end

  def self.all_students_in_grade_X(x)
    rows = DB[:conn].execute('SELECT * FROM students WHERE grade = ?', x)
    rows.map{ |row| self.new_from_db(row) }
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
end
