package com.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.Model.JobApplication;
import com.Utility.DBConnection;

public class JobApplicationDAO {

    private static DBConnection db = new DBConnection();

    /* ================= APPLY JOB ================= */
    public int applyJob(int jobId, int jobSeekerId) throws Exception {
        String sql = """
            INSERT INTO job_application (job_id, job_seeker_id)
            VALUES (?, ?)
        """;

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, jobId);
            ps.setInt(2, jobSeekerId);
            return ps.executeUpdate();
        }
    }

    /* ================= GET APPLICATIONS BY EMPLOYER =================
       Used by EMPLOYER dashboard
    */
    public List<JobApplication> getApplicationsByEmployer(int employerId) throws Exception {

        List<JobApplication> list = new ArrayList<>();

        String sql = """
            SELECT ja.*
            FROM job_application ja
            JOIN job j ON ja.job_id = j.job_id
            WHERE j.employer_id = ?
        """;

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, employerId);

            ResultSet rs = ps.executeQuery();
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

    /* ================= GET APPLICATIONS BY JOBSEEKERID =================
     * Used by JOBSEEKER dashboard to view their applications
    */
    public List<JobApplication> getApplicationsByJobseekerID(int jobseekerId) throws Exception {

        List<JobApplication> list = new ArrayList<>();

        String sql = "SELECT * FROM job_application WHERE job_seeker_id=?";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, jobseekerId);
            ResultSet rs = ps.executeQuery();

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

    /* ================= UPDATE APPLICATION STATUS =================
       Used by ADMIN + EMPLOYER
    */
    public boolean updateApplicationStatus(int appId, String status) throws Exception {

        String sql = """
            UPDATE job_application
            SET application_status=?
            WHERE application_id=?
        """;

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, appId);
            return ps.executeUpdate() > 0;
        }
    }

    /* ================= DELETE APPLICATION =================
       Used by ADMIN
    */
    public boolean deleteApplication(int appId) throws Exception {

        String sql = "DELETE FROM job_application WHERE application_id=?";

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, appId);
            return ps.executeUpdate() > 0;
        }
    }
    
    
}
