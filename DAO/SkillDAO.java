package com.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.Model.Skill;
import com.Utility.DBConnection;

public class SkillDAO {
	
	static DBConnection db = new DBConnection();

    public void addSkillToJobSeeker(int jobSeekerId, int skillId) throws Exception {
        String sql = "INSERT INTO job_seeker_skill VALUES(?,?)";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, jobSeekerId);
            ps.setInt(2, skillId);
            ps.executeUpdate();
        }
    }
    
    public int getSkillId(String skill) throws SQLException, ClassNotFoundException {
    	String sql = "select skill_id from skill where skill_name = ?";
        try (Connection con = db.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
        	ps.setString(1, skill);
        	
        	ResultSet rs = ps.executeQuery();
        	while(rs.next()) {
        		return rs.getInt("skill_id");
        	}
        }
    	return 0;
    	
    }
    
    
	public void deleteSkillFromJobSeeker(int jobSeekerId, int skillId) throws Exception {
		String sql = "DELETE FROM job_seeker_skill WHERE job_seeker_id = ? AND skill_id = ?";

		try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, jobSeekerId);
			ps.setInt(2, skillId);
			ps.executeUpdate();
		}
	}
    
	public List<Skill> getSkillsbyJobID(int jobId) throws Exception {
		String sql = """
				SELECT s.skill_id, s.skill_name
				FROM skill s
				JOIN job_skill js ON s.skill_id = js.skill_id
				WHERE js.job_id = ?
				""";
		
		List<Skill> skills = new ArrayList<>();
		try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, jobId);
			ResultSet rs = ps.executeQuery();
			
			while (rs.next()) {
				Skill s = new Skill();
				s.setSkillId(rs.getInt("skill_id"));
				s.setSkillName(rs.getString("skill_name"));
				skills.add(s);
			}
		}
		return skills;
	}
	
	public List<Skill> getSkillsbyJobSeekerID(int jobSeekerId) throws Exception {
        String sql = """
                SELECT s.skill_id, s.skill_name
                FROM skill s
                JOIN job_seeker_skill jss ON s.skill_id = jss.skill_id
                WHERE jss.job_seeker_id = ?
                """;
        List<Skill> skills = new ArrayList<>();

        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, jobSeekerId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Skill s = new Skill();
                s.setSkillId(rs.getInt("skill_id"));
                s.setSkillName(rs.getString("skill_name"));
                skills.add(s);
            }
        }
		return skills;
	}
	
	public List<Skill> getAllSkills() throws Exception {
        List<Skill> skills = new ArrayList<>();
        String sql = "SELECT skill_id, skill_name FROM skill";

        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Skill s = new Skill();
                s.setSkillId(rs.getInt("skill_id"));
                s.setSkillName(rs.getString("skill_name"));
                skills.add(s);
            }
        }
        return skills;
	
	}
	
}
	