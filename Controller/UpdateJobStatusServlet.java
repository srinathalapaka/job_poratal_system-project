package com.Controller;

import java.io.IOException;

import com.DAO.JobDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/UpdateJobStatusServlet")
public class UpdateJobStatusServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		JobDAO jobDAO = new JobDAO();
		
		int jobId = Integer.parseInt(request.getParameter("id"));
		String newStatus = request.getParameter("status");
		
		try {
			jobDAO.updateJobStatus(jobId, newStatus);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		response.sendRedirect("EmployerDashboard.jsp");
	}

}
