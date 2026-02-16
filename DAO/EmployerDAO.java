package com.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.Model.Employer;
import com.Utility.DBConnection;

public class EmployerDAO {
	
	DBConnection db = new DBConnection();
	public Employer login(String email, String password) throws Exception {
	    String sql = "SELECT * FROM employer WHERE email=? AND password=?";
	    try (Connection con = db.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setString(1, email);
	        ps.setString(2, password);
	        ResultSet rs = ps.executeQuery();

	        if (rs.next()) {
	            Employer e = new Employer();
	            e.setEmployerId(rs.getInt("employer_id"));
	            e.setCompanyName(rs.getString("company_name"));
	            return e;
	        }
	    }
	    return null;
	}
	
	//Employer
	public boolean addEmployer(Employer emp) throws Exception {
        String sql = """
            INSERT INTO employer(company_name, email, password, location)
            VALUES (?,?,?,?)
        """;

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, emp.getCompanyName());
            ps.setString(2, emp.getEmail());
            ps.setString(3, emp.getPassword());
            ps.setString(4, emp.getLocation());

            return ps.executeUpdate() > 0;
        }
    }

    
    public boolean updateEmployer(Employer emp) throws Exception {
        String sql = """
            UPDATE employer
            SET company_name=?, email=?, location=?
            WHERE employer_id=?
        """;

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, emp.getCompanyName());
            ps.setString(2, emp.getEmail());
            ps.setString(3, emp.getLocation());
            ps.setInt(4, emp.getEmployerId());

            return ps.executeUpdate() > 0;
        }
    }

    
    public boolean deleteEmployer(int employerId) throws Exception {
    	String deleteApplications = """
    	        DELETE ja FROM job_application ja
    	        JOIN job j ON ja.job_id = j.job_id
    	        WHERE j.employer_id=?
    	    """;

    	    String deleteJobs = "DELETE FROM job WHERE employer_id=?";
    	    String deleteEmployer = "DELETE FROM employer WHERE employer_id=?";

    	    try (Connection con = db.getConnection()) {
    	        con.setAutoCommit(false);

    	        try (PreparedStatement ps1 = con.prepareStatement(deleteApplications);
    	             PreparedStatement ps2 = con.prepareStatement(deleteJobs);
    	             PreparedStatement ps3 = con.prepareStatement(deleteEmployer)) {

    	            ps1.setInt(1, employerId);
    	            ps1.executeUpdate();

    	            ps2.setInt(1, employerId);
    	            ps2.executeUpdate();

    	            ps3.setInt(1, employerId);
    	            boolean success = ps3.executeUpdate() > 0;

    	            con.commit();
    	            return success;
    	        } catch (Exception e) {
    	            con.rollback();
    	            throw e;
    	        }
    	    }
    }
    
 

}
