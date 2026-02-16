<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.Model.*,com.DAO.*"%>

<%
JobSeeker jobseeker = (JobSeeker) session.getAttribute("jobseeker");
if (jobseeker == null) {
	response.sendRedirect("login.jsp");
	return;
}

JobDAO jobDao = new JobDAO();
JobApplicationDAO appDao = new JobApplicationDAO();
JobSeekerDAO jsDao = new JobSeekerDAO();
SkillDAO skillDao = new SkillDAO();

List<Job> allJobs = jobDao.getAllJobs();
List<Job> matchedJobs = jobDao.getMatchedJobs(jobseeker.getJobSeekerId());
List<JobApplication> applications = appDao.getApplicationsByJobseekerID(jobseeker.getJobSeekerId());
List<Skill> skills = skillDao.getSkillsbyJobSeekerID(jobseeker.getJobSeekerId());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Candidate Dashboard | CareerHub</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>


    <style>
        :root {
            --primary-blue: #0a66c2;
            --light-bg: #f3f2ef;
            --border-color: #e0e0e0;
        }
        

        body { background: var(--light-bg); font-family: 'Inter', sans-serif; color: #1d1d1d; }

        /* Sidebar & Layout */
        .sidebar { background: white; min-height: 100vh; border-right: 1px solid var(--border-color); padding-top: 20px; }
        .nav-link { color: #666; font-weight: 500; border-radius: 8px; margin: 5px 15px; transition: 0.2s; }
        .nav-link:hover, .nav-link.active { background: #f0f7ff; color: var(--primary-blue); }

        /* Cards */
        .card { border: none; border-radius: 10px; box-shadow: 0 0 0 1px rgba(0,0,0,0.08); margin-bottom: 20px; }
        .job-card:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.1); transition: 0.3s; }

        /* Skill Badges */
        .skill-badge { background: #e7f3ff; color: var(--primary-blue); border-radius: 20px; padding: 5px 15px; font-size: 0.85rem; font-weight: 600; display: inline-block; margin: 3px; }
        
        /* Filter Switch */
        .filter-toggle { background: white; padding: 5px; border-radius: 50px; display: inline-flex; border: 1px solid var(--border-color); }
        .btn-check:checked + .btn-outline-primary { background-color: var(--primary-blue); border-color: var(--primary-blue); }
        
        .select2-container { width: 100% !important; }
    	.select2-selection--multiple { border: 1px solid #dee2e6 !important; border-radius: 8px !important; }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        <div class="col-md-2 sidebar d-none d-md-block position-fixed">
            <div class="px-4 mb-4 text-primary fw-bold fs-4"><i class="bi bi-rocket-takeoff"></i> CareerHub</div>
            <nav class="nav flex-column">
                <a class="nav-link active" onclick="showTab('jobs-tab')"><i class="bi bi-house-door me-2"></i> Home</a>
                <a class="nav-link" onclick="showTab('apps-tab')"><i class="bi bi-file-earmark-check me-2"></i> Applications</a>
                <a class="nav-link" onclick="showTab('profile-tab')"><i class="bi bi-person-gear me-2"></i> Settings</a>
                <hr class="mx-3">
                <a href="LogoutServlet" class="nav-link text-danger"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
            </nav>
        </div>

        <div class="col-md-7 offset-md-2 p-4">
            
            <div id="jobs-tab" class="content-section">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4 class="fw-bold m-0">Discover Opportunities</h4>
                    
                    <div class="filter-toggle">
                        <input type="radio" class="btn-check" name="jobType" id="all" checked onchange="toggleJobs('all')">
                        <label class="btn btn-sm btn-outline-primary rounded-pill border-0 px-3" for="all">All Jobs</label>

                        <input type="radio" class="btn-check" name="jobType" id="matched" onchange="toggleJobs('matched')">
                        <label class="btn btn-sm btn-outline-primary rounded-pill border-0 px-3" for="matched">Matched for You</label>
                    </div>
                </div>

                <div id="all-jobs-list">
                    <% for(Job j : allJobs) { 
                        Employer emp = jsDao.getEmployerById(j.getEmployerId());
                    %>
                    <div class="card job-card p-4">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h5 class="fw-bold mb-1 text-primary"><%= j.getTitle() %></h5>
                                <p class="text-muted mb-2"><i class="bi bi-building"></i> <%= emp.getCompanyName() %> • <i class="bi bi-geo-alt"></i> <%= j.getLocation() %></p>
                                <p class="fw-bold text-success mb-0">₹ <%= j.getSalaryMin() %> - <%= j.getSalaryMax() %></p>
                            </div>
                            <div>
                                <a href="ApplyJobServlet?jobId=<%=j.getJobId()%>" class="btn btn-primary px-4 fw-bold">Apply Now</a>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>

                <div id="matched-jobs-list" style="display:none;">
                    <% if(matchedJobs.isEmpty()) { %>
                        <div class="alert alert-info">Update your skills to see matched jobs!</div>
                    <% } else {
                        for(Job mj : matchedJobs) { 
                        Employer emp = jsDao.getEmployerById(mj.getEmployerId());
                    %>
                        <div class="card job-card p-4">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h5 class="fw-bold mb-1 text-primary"><%= mj.getTitle() %></h5>
                                <p class="text-muted mb-2"><i class="bi bi-building"></i> <%= emp.getCompanyName() %> • <i class="bi bi-geo-alt"></i> <%= mj.getLocation() %></p>
                                <p class="fw-bold text-success mb-0">₹ <%= mj.getSalaryMin() %> - <%= mj.getSalaryMax() %></p>
                            </div>
                            <div>
                                <a href="ApplyJobServlet?jobId=<%=mj.getJobId()%>" class="btn btn-primary px-4 fw-bold">Apply Now</a>
                            </div>
                        </div>
                    </div>
                    <% }} %>
                </div>
            </div>

            <div id="apps-tab" class="content-section" style="display:none;">
                <h4 class="fw-bold mb-4">Track Applications</h4>
                <div class="card overflow-hidden">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Role</th>
                                <th>Company</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (JobApplication app : applications) { 
                                Job j = jobDao.getJobsByID(app.getJobId());
                                Employer emp = jsDao.getEmployerById(j.getEmployerId());
                            %>
                            <tr>
                                <td><span class="fw-bold text-dark"><%= j.getTitle() %></span></td>
                                <td><%= emp.getCompanyName() %></td>
                                <td><span class="badge rounded-pill bg-info-subtle text-info"><%= app.getApplicationStatus() %></span></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <div id="profile-tab" class="content-section" style="display:none;">
    <h4 class="fw-bold mb-4">Account Settings</h4>
    
    <div class="card p-4 mb-3">
        <h6 class="fw-bold"><i class="bi bi-shield-lock me-2"></i> Security</h6>
        <hr>
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <p class="mb-0 fw-medium">Password</p>
                <small class="text-muted">Change your account password regularly for safety.</small>
            </div>
            <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#changePasswordModal">
                Update Password
            </button>
        </div>
    </div>

    <div class="card p-4 mb-3 border-danger">
        <h6 class="fw-bold text-danger"><i class="bi bi-exclamation-triangle me-2"></i> Danger Zone</h6>
        <hr>
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <p class="mb-0 fw-medium">Deactivate Account</p>
                <small class="text-muted">Once deactivated, recruiters cannot see your profile.</small>
            </div>
            <button class="btn btn-sm btn-danger">Deactivate</button>
        </div>
    </div>
</div>
        </div>

        <div class="col-md-3 p-4">
            <div class="card p-3 text-center">
                <div class="avatar-bg mx-auto mb-2 text-primary fs-1"><i class="bi bi-person-circle"></i></div>
                <h6 class="fw-bold mb-0"><%= jobseeker.getName() %></h6>
                <p class="small text-muted"><%= jobseeker.getLocation() %></p>
                <button class="btn btn-sm btn-outline-primary w-100" data-bs-toggle="modal" data-bs-target="#editProfileModal">Edit Profile</button>
            </div>

            <div class="card p-3">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h6 class="fw-bold m-0">My Skills</h6>
                    <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#addSkillModal"><i class="bi bi-plus"></i></button>
                </div>
                <div>
                    <% for (Skill skill : skills) { %>
                        <span class="skill-badge"><%= skill.getSkillName() %></span>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>

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

<div class="modal fade" id="editProfileModal" tabindex="-1">
    <div class="modal-dialog">
        <form class="modal-content" action="EditJobSeeker" method="POST">
            <div class="modal-header border-0">
                <h5 class="modal-title fw-bold">Update Profile</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="id" value="<%= jobseeker.getJobSeekerId() %>">
                
                <div class="mb-3">
                    <label class="form-label small fw-semibold">Full Name</label>
                    <input type="text" name="name" class="form-control" value="<%= jobseeker.getName() %>" required>
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-semibold">Email Address</label>
                    <input type="email" name="email" class="form-control" value="<%= jobseeker.getEmail() %>" required>
                </div>
                
                <div class="row">
                    <div class="col-md-8 mb-3">
                        <label class="form-label small fw-semibold">Location</label>
                        <input type="text" name="location" class="form-control" value="<%= jobseeker.getLocation() %>" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label small fw-semibold">Exp (Years)</label>
                        <input type="number" name="experience" class="form-control" value="<%= jobseeker.getExperienceYears() %>" required>
                    </div>
                </div>
            </div>
            <div class="modal-footer border-0">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary px-4">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<div class="modal fade" id="changePasswordModal" tabindex="-1">
    <div class="modal-dialog">
        <form class="modal-content" action="ChangePasswordServlet" method="POST" id="passwordForm">
            <div class="modal-header border-0">
                <h5 class="modal-title fw-bold">Update Security</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label small fw-semibold">Current Password</label>
                    <input type="password" name="currentPassword" class="form-control" placeholder="Required to verify identity" required>
                </div>
                <hr>
                <div class="mb-3">
                    <label class="form-label small fw-semibold">New Password</label>
                    <input type="password" name="newPassword" id="newPassword" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label small fw-semibold">Confirm New Password</label>
                    <input type="password" id="confirmPassword" class="form-control" required>
                    <div id="passError" class="text-danger small mt-1" style="display:none;">Passwords do not match!</div>
                </div>
            </div>
            <div class="modal-footer border-0">
                <button type="submit" class="btn btn-primary w-100">Save New Password</button>
            </div>
        </form>
    </div>
</div>	






<script>
    function toggleJobs(type) {
        document.getElementById('all-jobs-list').style.display = (type === 'all') ? 'block' : 'none';
        document.getElementById('matched-jobs-list').style.display = (type === 'matched') ? 'block' : 'none';
    }

    function showTab(tabId) {
        document.querySelectorAll('.content-section').forEach(s => s.style.display = 'none');
        document.getElementById(tabId).style.display = 'block';
        document.querySelectorAll('.nav-link').forEach(l => l.classList.remove('active'));
        event.target.classList.add('active');
    }
    
    $(document).ready(function() {
        $('.select2-skills').select2({
            dropdownParent: $('#addSkillModal'),
            theme: "classic", // Optional: adjusts look
            placeholder: "Search and select skills..."
        });
    });
    
    document.getElementById('passwordForm').onsubmit = function(e) {
        const pass = document.getElementById('newPassword').value;
        const confirm = document.getElementById('confirmPassword').value;
        if (pass !== confirm) {
            document.getElementById('passError').style.display = 'block';
            return false;
        }
    };
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>