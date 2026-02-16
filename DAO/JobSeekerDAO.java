package com.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.Model.Employer;
import com.Model.JobSeeker;
import com.Utility.DBConnection;

public class JobSeekerDAO {
	
	static DBConnection db = new DBConnection();
	
    public JobSeeker login(String email, String password) throws Exception {
        String sql = "SELECT * FROM job_seeker WHERE email=? AND password=?";
        JobSeeker js = null;

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                js = new JobSeeker();
                js.setJobSeekerId(rs.getInt("job_seeker_id"));
                js.setName(rs.getString("name"));
                js.setEmail(rs.getString("email"));
                js.setLocation(rs.getString("location"));
                js.setExperienceYears(rs.getInt("experience_years"));
                js.setResumePath(rs.getString("resume_path"));
            }
        }
        return js;
    }
    
    public boolean addJobSeeker(JobSeeker js) {

        String sql = """
            INSERT INTO job_seeker
            (name, email, password, experience_years, resume_path, location)
            VALUES (?,?,?,?,?,?)
        """;

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, js.getName());
            ps.setString(2, js.getEmail());
            ps.setString(3, js.getPassword());
            ps.setInt(4, js.getExperienceYears());
            ps.setString(5, js.getResumePath());
            ps.setString(6, js.getLocation());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public void registerWithSkills(JobSeeker js, String[] skillIds) throws Exception {

        String insertJobSeeker = """
            INSERT INTO job_seeker
            (name, email, password, experience_years, resume_path, location)
            VALUES (?,?,?,?,?,?)
        """;

        String insertSkill = """
            INSERT INTO job_seeker_skill (job_seeker_id, skill_id)
            VALUES (?,?)
        """;

        Connection con = null;

        try {
            con = db.getConnection();
            con.setAutoCommit(false); 

           
            PreparedStatement ps =
                con.prepareStatement(insertJobSeeker, Statement.RETURN_GENERATED_KEYS);

            ps.setString(1, js.getName());
            ps.setString(2, js.getEmail());
            ps.setString(3, js.getPassword());
            ps.setInt(4, js.getExperienceYears());
            ps.setString(5, js.getResumePath());
            ps.setString(6, js.getLocation());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            rs.next();
            int jobSeekerId = rs.getInt(1);

           
            PreparedStatement psSkill = con.prepareStatement(insertSkill);
            for (String skillId : skillIds) {
                psSkill.setInt(1, jobSeekerId);
                psSkill.setInt(2, Integer.parseInt(skillId));
                psSkill.addBatch();
            }
            psSkill.executeBatch();

            con.commit(); 

        } catch (Exception e) {
            if (con != null) con.rollback(); 
            throw e;
        } finally {
            if (con != null) con.close();
        }
    }
    
    public boolean updateJobSeeker(JobSeeker js) throws Exception {
        String sql = """
            UPDATE job_seeker
            SET name=?, email=?, experience_years=?, location=?
            WHERE job_seeker_id=?
        """;

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, js.getName());
            ps.setString(2, js.getEmail());
            ps.setInt(3, js.getExperienceYears());
            ps.setString(4, js.getLocation());
            ps.setInt(5, js.getJobSeekerId());

            return ps.executeUpdate() > 0;
        }
    }

    
    public boolean deleteJobSeeker(int jobSeekerId) throws Exception {
        String sql = "DELETE FROM job_seeker WHERE job_seeker_id=?";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, jobSeekerId);
            return ps.executeUpdate() > 0;
        }
    }
    
    public JobSeeker getJobSeekerById(int id) throws Exception {
        String sql = "SELECT * FROM job_seeker WHERE job_seeker_id=?";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                JobSeeker js = new JobSeeker();
                js.setJobSeekerId(id);
                js.setName(rs.getString("name"));
                js.setEmail(rs.getString("email"));
                js.setLocation(rs.getString("location"));
                js.setExperienceYears(rs.getInt("experience_years"));
                js.setResumePath(rs.getString("resume_path"));
                return js;
            }
        }
        return null;
    }
    
	public Employer getEmployerById(int id) throws Exception {
		String sql = "SELECT * FROM employer WHERE employer_id=?";
		try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				Employer e = new Employer();
				e.setEmployerId(rs.getInt("employer_id"));
				e.setCompanyName(rs.getString("company_name"));
				e.setEmail(rs.getString("email"));
				e.setLocation(rs.getString("location"));
				return e;
			}
		}
		return null;
	}
   
	public boolean checkOldPassword(int userId, String currentPassword) {
	    boolean isValid = false;
	    String sql = "SELECT password FROM job_seeker WHERE job_seeker_id = ?";
	    
	    try (Connection con = db.getConnection(); 
	         PreparedStatement ps = con.prepareStatement(sql)) {
	        
	        ps.setInt(1, userId);
	        ResultSet rs = ps.executeQuery();
	        
	        if (rs.next()) {
	            String dbPassword = rs.getString("password");

	            if (dbPassword.equals(currentPassword)) {
	                isValid = true;
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return isValid;
	}

	public boolean updatePassword(int userId, String newPassword) {
	    String sql = "UPDATE job_seeker SET password = ? WHERE job_seeker_id = ?";
	    try (Connection con = db.getConnection(); 
	         PreparedStatement ps = con.prepareStatement(sql)) {
	        
	        ps.setString(1, newPassword);
	        ps.setInt(2, userId);
	        
	        return ps.executeUpdate() > 0;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    }
	}

}
