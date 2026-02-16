package com.Controller;

import java.io.IOException;

import com.DAO.JobSeekerDAO;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DeleteJobSeeker")
public class DeleteJobSeekerServlet extends HttpServlet {

    
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        try {
			new JobSeekerDAO().deleteJobSeeker(id);
		} catch (Exception e) {
			e.printStackTrace();
		}

        response.sendRedirect("AdminDashboard.jsp");
    }
}

