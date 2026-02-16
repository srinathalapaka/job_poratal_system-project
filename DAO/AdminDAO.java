package com.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.Model.Admin;
import com.Model.Employer;
import com.Model.Job;
import com.Model.JobApplication;
import com.Model.JobSeeker;
import com.Utility.DBConnection;

public class AdminDAO {
	DBConnection db = new DBConnection();
	
	public Admin login(String email, String password) throws Exception {
	    String sql = "SELECT * FROM admins WHERE email=? AND password=?";
	    try (Connection con = db.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setString(1, email);
	        ps.setString(2, password);
	        ResultSet rs = ps.executeQuery();

	        if (rs.next()) {
	            Admin a = new Admin();
	            a.setAdminId(rs.getInt("admin_id"));
	            a.setName(rs.getString("name"));
	            return a;
	        }
	    }
	    return null;
	}
	
    public List<Employer> getAllEmployers() throws Exception {
        List<Employer> list = new ArrayList<>();
        String sql = "SELECT * FROM employer";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Employer e = new Employer();
                e.setEmployerId(rs.getInt("employer_id"));
                e.setCompanyName(rs.getString("company_name"));
                e.setEmail(rs.getString("email"));
                e.setLocation(rs.getString("location"));
                list.add(e);
            }
        }
        return list;
    }
    
    public List<JobSeeker> getAllJobSeekers() throws Exception {
        List<JobSeeker> list = new ArrayList<>();
        String sql = "SELECT * FROM job_seeker";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                JobSeeker js = new JobSeeker();
                js.setJobSeekerId(rs.getInt("job_seeker_id"));
                js.setName(rs.getString("name"));
                js.setEmail(rs.getString("email"));
                js.setExperienceYears(rs.getInt("experience_years"));
                js.setLocation(rs.getString("location"));
                list.add(js);
            }
        }
        return list;
    }
    
    public List<JobApplication> getAllApplications() throws Exception {
        List<JobApplication> list = new ArrayList<>();
        String sql = "SELECT * FROM job_application";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                JobApplication ja = new JobApplication();
                ja.setApplicationId(rs.getInt("application_id"));
                ja.setJobId(rs.getInt("job_id"));
                ja.setJobSeekerId(rs.getInt("job_seeker_id"));
                ja.setApplicationStatus(rs.getString("application_status"));
                list.add(ja);
            }
        }
        return list;
    }

    

    
}


