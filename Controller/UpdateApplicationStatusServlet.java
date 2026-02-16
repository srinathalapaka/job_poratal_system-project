package com.Controller;

import java.io.IOException;

import com.DAO.JobApplicationDAO;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/UpdateApplicationStatusServlet")
public class UpdateApplicationStatusServlet extends HttpServlet {

   
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
		
		HttpSession session = request.getSession();
		
        int appId = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");

        try {
			new JobApplicationDAO().updateApplicationStatus(appId, status);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
        
        if(session.getAttribute("admin") != null) {
        response.sendRedirect("AdminDashboard.jsp");
    }else {
    	response.sendRedirect("EmployerDashboard.jsp");
    }
        
	}
}
