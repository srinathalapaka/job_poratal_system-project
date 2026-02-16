package com.Controller;

import java.io.IOException;

import com.DAO.JobApplicationDAO;
import com.Model.JobSeeker;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/ApplyJobServlet")
public class ApplyJobServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    String jobIdRaw = request.getParameter("jobId");
	    
	    
	    JobSeeker jobseeker = (JobSeeker) request.getSession().getAttribute("jobseeker");

	    if (jobIdRaw != null && jobseeker != null) {
	        int jobId = Integer.parseInt(jobIdRaw);
	        int jobSeekerId = jobseeker.getJobSeekerId(); 
	        
	        JobApplicationDAO jaDao = new JobApplicationDAO();
	        try {
	            int n = jaDao.applyJob(jobId, jobSeekerId);
	            if(n > 0) {
	                response.sendRedirect("JobseekerDashboard.jsp?message=Application+Success");
	            } else {
	                response.sendRedirect("JobseekerDashboard.jsp?error=Already+Applied");
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	            response.sendRedirect("JobseekerDashboard.jsp?error=Server+Error");
	        }
	    } else {
	        response.sendRedirect("login.jsp");
	    }
	}

}
