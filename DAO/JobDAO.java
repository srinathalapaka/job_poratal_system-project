package com.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.Model.Job;
import com.Utility.DBConnection;

public class JobDAO {
	static DBConnection db = new DBConnection();

	public int addJob(Job job) throws Exception {
		String sql = """
				INSERT INTO job (
				    employer_id, title, description, location,
				    salary_min, salary_max, status
				) VALUES (?,?,?,?,?,?, 'OPEN')
				""";

		try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, job.getEmployerId());
			ps.setString(2, job.getTitle());
			ps.setString(3, job.getDescription());
			ps.setString(4, job.getLocation());
			ps.setDouble(5, job.getSalaryMin());
			ps.setDouble(6, job.getSalaryMax());

			return ps.executeUpdate();
		}
	}

	public List<Job> getJobsByEmployer(int empId) throws Exception {
		List<Job> list = new ArrayList<>();
		String sql = "SELECT * FROM job WHERE status='OPEN' and employer_id = ?";

		try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql);

		) {
			ps.setInt(1, empId);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
			    Job j = new Job();
			    j.setJobId(rs.getInt("job_id"));
			    j.setTitle(rs.getString("title"));
			    j.setLocation(rs.getString("location"));
			    j.setSalaryMin(rs.getDouble("salary_min"));
			    j.setSalaryMax(rs.getDouble("salary_max"));
			    j.setStatus(rs.getString("status")); 
			    j.setEmployerId(rs.getInt("employer_id"));
			    j.setDescription(rs.getString("description"));	;
			    list.add(j);
			}

		}
		return list;
	}
	
	public Job getJobsByID(int id) throws Exception {
		
		String sql = "SELECT * FROM job WHERE status='OPEN' and job_id = ?";

		try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql);

		) {
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
			    Job j = new Job();
			    j.setJobId(rs.getInt("job_id"));
			    j.setTitle(rs.getString("title"));
			    j.setLocation(rs.getString("location"));
			    j.setSalaryMin(rs.getDouble("salary_min"));
			    j.setSalaryMax(rs.getDouble("salary_max"));
			    j.setStatus(rs.getString("status")); 
			    j.setEmployerId(rs.getInt("employer_id"));
			    j.setDescription(rs.getString("description"));	
			    return j;
			}

		}
		return null;
	}

	public List<Job> getMatchedJobs(int jobSeekerId) throws Exception {

		List<Job> list = new ArrayList<>();

		String sql = """
				    SELECT j.job_id, j.title, j.location,
				           j.salary_min, j.salary_max,j.employer_id, j.description,j.status,
				           COUNT(js.skill_id) AS matched_skills
				    FROM job j
				    JOIN job_skill js ON j.job_id = js.job_id
				    JOIN job_seeker_skill jss ON js.skill_id = jss.skill_id
				    WHERE jss.job_seeker_id = ?
				      AND j.status = 'OPEN'
				    GROUP BY j.job_id
				    ORDER BY matched_skills DESC
				""";

		try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, jobSeekerId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Job j = new Job();
				j.setJobId(rs.getInt("job_id"));
				j.setTitle(rs.getString("title"));
				j.setLocation(rs.getString("location"));
				j.setSalaryMin(rs.getDouble("salary_min"));
				j.setSalaryMax(rs.getDouble("salary_max"));
				j.setEmployerId(rs.getInt("employer_id"));
				j.setDescription(rs.getString("description"));
				j.setStatus(rs.getString("status"));
				list.add(j);
			}
		}
		return list;
	}
	
	
	public void updateJobStatus(int jobId, String status) throws Exception {
		String sql = "UPDATE job SET status=? WHERE job_id=?";

		try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, status);
			ps.setInt(2, jobId);
			ps.executeUpdate();
		}
	}
	
    public List<Job> getAllJobs() throws Exception {
        List<Job> list = new ArrayList<>();
        String sql = "SELECT * FROM job WHERE status='OPEN'";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Job j = new Job();
                j.setJobId(rs.getInt("job_id"));
                j.setTitle(rs.getString("title"));
                j.setLocation(rs.getString("location"));
                j.setSalaryMin(rs.getDouble("salary_min"));
                j.setSalaryMax(rs.getDouble("salary_max"));
                j.setEmployerId(rs.getInt("employer_id"));
				j.setDescription(rs.getString("description"));
                
                list.add(j);
            }
        }
        return list;
    }

}
