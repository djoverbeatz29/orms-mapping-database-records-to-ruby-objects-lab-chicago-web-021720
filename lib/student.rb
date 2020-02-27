class Student
  attr_accessor :id, :name, :grade

  def initialize(name = nil, grade = nil, id = nil)
      @id = id
      @name = name
      @grade = grade
  end

  def self.wrapper(db, n = nil)
    ob = db.map { |row| self.new_from_db(row) }
    n ? ob.first(n) : ob
  end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    ho = self.new(row[1], row[2], row[0])
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    DB[:conn].execute("SELECT * FROM students;").map {
      |row| self.new_from_db(row) }
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    DB[:conn].execute("SELECT * FROM students WHERE name = ? LIMIT 1;", name).map { |row| self.new_from_db(row) }.first
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
    DB[:conn].execute("SELECT * FROM students WHERE grade = 9;")
  end

  def self.students_below_12th_grade
    DB[:conn].execute("SELECT * FROM students WHERE grade < 12;").map {
      |row| self.new_from_db(row) }
  end

  def self.first_X_students_in_grade_10(x)
    DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT ?;", x).map {
      |row| self.new_from_db(row) }.first(x)
  end

  def self.first_student_in_grade_10
    DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT 1;").map {
      |row| self.new_from_db(row) }.first
  end

  def self.all_students_in_grade_X(grade)
    DB[:conn].execute("SELECT * FROM students WHERE grade = ?; ", grade)
  end

end
