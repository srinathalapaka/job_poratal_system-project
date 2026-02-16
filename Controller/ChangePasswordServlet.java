package com.Controller;

import java.io.IOException;

import com.DAO.JobSeekerDAO;
import com.Model.JobSeeker;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/ChangePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String currPass = request.getParameter("currentPassword");
		String newPass = request.getParameter("newPassword");
		

		JobSeekerDAO dao = new JobSeekerDAO();
		HttpSession session = request.getSession();
		
		JobSeeker jseeker = (JobSeeker) session.getAttribute("jobseeker");
		if(jseeker != null) {
			int uid = jseeker.getJobSeekerId();
			
			if(dao.checkOldPassword(uid, currPass)) {
				if(dao.updatePassword(uid, newPass)) {
					response.sendRedirect("JobseekerDashboard.jsp?success=passwordChanged");
				} else {
					response.sendRedirect("JobseekerDashboard.jsp?error=updateFailed");
				}
			}
			else {
				response.sendRedirect("JobseekerDashboard.jsp?error=incorrectCurrentPassword");
			}
		}
		else {
			response.sendRedirect("ChangePassword.jsp?error=userNotLoggedIn");
		}
		
		
	}

}
