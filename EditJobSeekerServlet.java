package com.Controller;

import java.io.IOException;

import com.DAO.JobSeekerDAO;
import com.Model.JobSeeker;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/EditJobSeeker")
public class EditJobSeekerServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        JobSeeker js = new JobSeeker();
        js.setJobSeekerId(Integer.parseInt(request.getParameter("id")));
        js.setName(request.getParameter("name"));
        js.setEmail(request.getParameter("email"));
        js.setLocation(request.getParameter("location"));
        js.setExperienceYears(Integer.parseInt(request.getParameter("experience")));

        try {
            JobSeekerDAO dao = new JobSeekerDAO();
            dao.updateJobSeeker(js);

            request.getSession().setAttribute("jobseeker", js);
            
            response.sendRedirect("JobseekerDashboard.jsp?success=profileUpdated");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("JobseekerDashboard.jsp?error=updateFailed");
        }
    }
}

