import Buffer "mo:base/Buffer";
import {toText} "mo:base/Nat";

actor HealthRecordSystem {

  // Define a type for students
  type Student = {
    id: Text;
    name: Text;
    age: Nat;
  };

  // Define a type for health records
  type HealthRecord = {
    studentId: Text;
    visitDate: Text;
    reason: Text;
    treatment: Text;
    timestamp: Nat;
  };

  // Buffers to store students and health records
  var studentDB = Buffer.Buffer<Student>(0);
  var healthRecordDB = Buffer.Buffer<HealthRecord>(0);

  // Function to register a student
  public func registerStudent(student: Student): async Text {
    studentDB.add(student);
    return "Successfully registered student: " # student.name;
  };

  // Function to record a health visit
  public func recordHealthVisit(healthRecord: HealthRecord): async Text {
    healthRecordDB.add(healthRecord);
    return "Health visit recorded!"
  };

  // Function to get a summary of health visits for a specific student
  public query func getHealthSummary(studentId: Text): async Text {
    var visitCount = 0;
    var details = "";

    // Filter health records for the specified student
    let healthSnapshot = Buffer.toArray(healthRecordDB);
    for (record in healthSnapshot.vals()) {
      if (record.studentId == studentId) {
        visitCount += 1;
        details #= "Visit Date: " # record.visitDate # ", Reason: " # record.reason # 
                  ", Treatment: " # record.treatment # ", Timestamp: " # toText(record.timestamp) # "\n";
      };
    };

    if (visitCount == 0) {
      return "No health records found for student ID: " # studentId;
    } else {
      return "Health records for student ID: " # studentId # " (Total visits: " # toText(visitCount) # "):\n" # details;
    };
  };

  // Function to get a summary of all health visits in the health center
  public query func getAllHealthRecords(): async Text {
    var totalVisits = 0;
    var details = "";

    // Retrieve all health records
    let healthSnapshot = Buffer.toArray(healthRecordDB);
    for (record in healthSnapshot.vals()) {
      totalVisits += 1;
      details #= "Student ID: " # record.studentId # ", Visit Date: " # record.visitDate # 
                ", Reason: " # record.reason # ", Treatment: " # record.treatment # 
                ", Timestamp: " # toText(record.timestamp) # "\n";
    };

    if (totalVisits == 0) {
      return "No health records found.";
    } else {
      return "Total Health Records: " # toText(totalVisits) # "\n" # details;
    };
  };
}
