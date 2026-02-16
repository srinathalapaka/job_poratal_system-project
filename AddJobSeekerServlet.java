package com.Controller;

import java.io.IOException;

import com.DAO.JobSeekerDAO;
import com.Model.JobSeeker;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AddJobSeeker")
public class AddJobSeekerServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        JobSeeker js = new JobSeeker();
        js.setName(request.getParameter("name"));
        js.setEmail(request.getParameter("email"));
        js.setPassword(request.getParameter("password"));
        js.setExperienceYears(Integer.parseInt(request.getParameter("experience")));
        js.setResumePath(request.getParameter("resume"));

        new JobSeekerDAO().addJobSeeker(js);
        response.sendRedirect("AdminDashboard.jsp");
    }
}

