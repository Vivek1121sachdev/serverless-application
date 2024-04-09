import React, { useState, useEffect } from "react";
import axios from "axios";

const API_BASE_URL =
  "https://lcx16t5xu2.execute-api.us-east-1.amazonaws.com/dev";

const App = () => {
  const [students, setStudents] = useState([]);
  const [newStudent, setNewStudent] = useState({
    studentId: "",
    name: "",
    email: "",
    // Add other fields as needed
  });

  useEffect(() => {
    fetchStudents();
  }, []);

  const fetchStudents = async () => {
    try {
      const response = await axios.get(`${API_BASE_URL}/students`);
      setStudents(response.data.students);
    } catch (error) {
      console.error("Error fetching students:", error);
    }
  };

  const addStudent = async () => {
    try {
      await axios.post(`${API_BASE_URL}/student`, newStudent);
      fetchStudents(); // Refresh the list after adding
    } catch (error) {
      console.error("Error adding student:", error);
    }
  };

  const deleteStudent = async (studentId) => {
    try {
      const payload = { studentId }; // Construct the request payload
      const response = await axios.delete(`${API_BASE_URL}/student`, {
        data: payload,
      });
      console.log("Response from delete:", response.data); // Log the response body
      fetchStudents(); // Refresh the list after deleting
      return response.data; // Return the response body
    } catch (error) {
      console.error("Error deleting student:", error);
      return { error: "Delete operation failed" }; // Return an error message in case of failure
    }
  };

  return (
    <div>
      <h1>Students</h1>
      <ul>
        {students.map((student) => (
          <li key={student.studentId}>
            {student.name} - {student.email}
            <button onClick={() => deleteStudent(student.studentId)}>
              Delete
            </button>
          </li>
        ))}
      </ul>
      <h2>Add New Student</h2>
      <form
        onSubmit={(e) => {
          e.preventDefault();
          addStudent();
        }}
      >
        <input
          type="text"
          placeholder="Student ID"
          value={newStudent.studentId}
          onChange={(e) =>
            setNewStudent({ ...newStudent, studentId: e.target.value })
          }
        />
        <input
          type="text"
          placeholder="Name"
          value={newStudent.name}
          onChange={(e) =>
            setNewStudent({ ...newStudent, name: e.target.value })
          }
        />
        <input
          type="email"
          placeholder="Email"
          value={newStudent.email}
          onChange={(e) =>
            setNewStudent({ ...newStudent, email: e.target.value })
          }
        />
        {/* Add other input fields as needed */}
        <button type="submit">Add Student</button>
      </form>
    </div>
  );
};

export default App;


// import React, { useState, useEffect } from "react";
// import axios from "axios";
// import fs from "fs"; // Import the fs module

// const App = () => {
//   const [students, setStudents] = useState([]);
//   const [newStudent, setNewStudent] = useState({
//     studentId: "",
//     name: "",
//     email: "",
//     // Add other fields as needed
//   });

//   useEffect(() => {
//     fetchStudents();
//   }, []);

//   // Function to read the API base URL from the text file
//   const getApiBaseUrl = () => {
//     try {
//       const apiUrl = fs.readFileSync("../../Backend/api-gw-invoke-url.txt", "utf8").trim();
//       return apiUrl;
//     } catch (error) {
//       console.error("Error reading API URL from file:", error);
//       // Return a default URL or handle the error as needed
//       return "https://default-api-url.com";
//     }
//   };

//   // Use the function to get the API base URL dynamically
//   const API_BASE_URL = getApiBaseUrl();

//   const fetchStudents = async () => {
//     try {
//       const response = await axios.get(`${API_BASE_URL}/students`);
//       setStudents(response.data.students);
//     } catch (error) {
//       console.error("Error fetching students:", error);
//     }
//   };

//   const addStudent = async () => {
//     try {
//       await axios.post(`${API_BASE_URL}/student`, newStudent);
//       fetchStudents(); // Refresh the list after adding
//     } catch (error) {
//       console.error("Error adding student:", error);
//     }
//   };

//   const deleteStudent = async (studentId) => {
//     try {
//       const payload = { studentId }; // Construct the request payload
//       const response = await axios.delete(`${API_BASE_URL}/student`, {
//         data: payload,
//       });
//       console.log("Response from delete:", response.data); // Log the response body
//       fetchStudents(); // Refresh the list after deleting
//       return response.data; // Return the response body
//     } catch (error) {
//       console.error("Error deleting student:", error);
//       return { error: "Delete operation failed" }; // Return an error message in case of failure
//     }
//   };

//   return (
//     <div>
//       <h1>Students</h1>
//       <ul>
//         {students.map((student) => (
//           <li key={student.studentId}>
//             {student.name} - {student.email}
//             <button onClick={() => deleteStudent(student.studentId)}>
//               Delete
//             </button>
//           </li>
//         ))}
//       </ul>
//       <h2>Add New Student</h2>
//       <form
//         onSubmit={(e) => {
//           e.preventDefault();
//           addStudent();
//         }}
//       >
//         <input
//           type="text"
//           placeholder="Student ID"
//           value={newStudent.studentId}
//           onChange={(e) =>
//             setNewStudent({ ...newStudent, studentId: e.target.value })
//           }
//         />
//         <input
//           type="text"
//           placeholder="Name"
//           value={newStudent.name}
//           onChange={(e) =>
//             setNewStudent({ ...newStudent, name: e.target.value })
//           }
//         />
//         <input
//           type="email"
//           placeholder="Email"
//           value={newStudent.email}
//           onChange={(e) =>
//             setNewStudent({ ...newStudent, email: e.target.value })
//           }
//         />
//         {/* Add other input fields as needed */}
//         <button type="submit">Add Student</button>
//       </form>
//     </div>
//   );
// };

// export default App;
