<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.util.*,com.Model.*,com.DAO.SkillDAO"%>
    
    <%
    SkillDAO skillDao = new SkillDAO();
    
  
    %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="JobSeekerRegisterServlet"
      method="post"
      enctype="multipart/form-data">

    <!-- Basic Details -->
    <input type="text" name="name" placeholder="Full Name" required>
    <input type="email" name="email" placeholder="Email" required>
    <input type="password" name="password" required>
    <input type="number" name="experience" placeholder="Experience (Years)">
    <input type="text" name="location" placeholder="Location">

    <!-- Skills -->
    <h4>Select Skills</h4>
<div class="modal fade" id="addSkillModal" tabindex="-1">
    <div class="modal-dialog">
        <form class="modal-content" action="AddSkillServlet" method="POST">
            <div class="modal-header border-0">
                <h5 class="modal-title fw-bold">Add New Skills</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <label class="form-label fw-semibold small">Select Skills</label>
                <select name="skills" class="form-select select2-skills" multiple="multiple" style="width: 100%;" data-placeholder="Choose skills..." required>
                    <%
                    // Assuming 'allSkills' is available in your request/session scope from a DAO
                    List<Skill> allSkills = skillDao.getAllSkills(); // Make sure this method exists in your SkillDAO
                    if (allSkills != null) {
                        for (Skill s : allSkills) {
                    %>
                    <option value="<%=s.getSkillId()%>"><%=s.getSkillName()%></option>
                    <%
                        }
                    }
                    %>
                </select>
            </div>
            <div class="modal-footer border-0">
                <button type="submit" class="btn btn-primary w-100">Add to Profile</button>
            </div>
        </form>
    </div>
</div>

    <!-- Resume -->
    <input type="file" name="resume" required>

    <button type="submit">Register</button>
</form>
	
</body>
</html>