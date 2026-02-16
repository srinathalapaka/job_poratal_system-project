package com.Controller;

import java.io.IOException;

import com.DAO.JobSeekerDAO;
import com.Model.JobSeeker;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class ViewJobSeekerServlet
 */
@WebServlet("/ViewJobSeekerServlet")
public class ViewJobSeekerServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		JobSeekerDAO jsDAO = new JobSeekerDAO();
		
		
		
		try {
			JobSeeker js = jsDAO.getJobSeekerById(Integer.parseInt(request.getParameter("id")));
			
			if (js == null) {
				response.sendRedirect("EmployerDashboard.jsp?error=JobSeekerNotFound");
				return;
			}
			System.out.println("JobSeeker found: " + js.getName());
			request.setAttribute("jobSeeker", js);
			request.getRequestDispatcher("ViewJobSeeker.jsp").forward(request, response);
			
		} catch (Exception e) {
			
			e.printStackTrace();
		}
			
		
		
	}

}
