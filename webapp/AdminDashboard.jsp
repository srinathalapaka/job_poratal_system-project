<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.DAO.*,com.Model.*"%>

<%
Admin admin = (Admin) session.getAttribute("admin");
if (admin == null) {
	response.sendRedirect("login.jsp");
	return;
}

AdminDAO adao = new AdminDAO();
List<Employer> employers = adao.getAllEmployers();
List<JobSeeker> jobSeekers = adao.getAllJobSeekers();
List<JobApplication> applications = adao.getAllApplications();

JobDAO jobDao = new JobDAO();
List<Job> jobs = jobDao.getAllJobs();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Admin Dashboard | CareerHub</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap"
	rel="stylesheet">

<style>
:root {
	--sidebar-bg: #0f172a;
	--accent-color: #10b981;
	--hover-color: #1e293b;
	--body-bg: #f8fafc;
}

body {
	background: var(--body-bg);
	font-family: 'Inter', sans-serif;
	overflow-x: hidden;
}

/* SIDEBAR STYLING */
.sidebar {
	background: var(--sidebar-bg);
	min-height: 100vh;
	color: white;
	transition: all 0.3s;
	position: sticky;
	top: 0;
	z-index: 1000;
}

.sidebar-header {
	padding: 2rem 1rem;
	background: rgba(255, 255, 255, 0.05);
	margin-bottom: 1rem;
}

.sidebar a {
	display: flex;
	align-items: center;
	padding: 12px 20px;
	color: #94a3b8;
	text-decoration: none;
	border-radius: 8px;
	margin: 4px 15px;
	transition: 0.2s;
	cursor: pointer;
}

.sidebar a i {
	margin-right: 12px;
	font-size: 1.2rem;
}

.sidebar a:hover, .sidebar a.active {
	background: var(--accent-color);
	color: white;
}

/* MAIN CONTENT AREA */
.main {
	padding: 2rem;
}

.stat-card {
	background: white;
	border: none;
	border-radius: 15px;
	padding: 20px;
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
	transition: transform 0.2s;
}

.stat-card:hover {
	transform: translateY(-5px);
}

.table-card {
	background: white;
	border-radius: 20px;
	padding: 25px;
	box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
	border: 1px solid rgba(0, 0, 0, 0.05);
	display: none; /* Controlled by JS */
	animation: fadeIn 0.4s ease-out;
}

@
keyframes fadeIn {from { opacity:0;
	transform: translateY(10px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}

/* TABLE CUSTOMIZATION */
.table thead th {
	background-color: #f1f5f9;
	color: #475569;
	text-transform: uppercase;
	font-size: 0.75rem;
	letter-spacing: 0.05em;
	border: none;
	padding: 15px;
}

.table td {
	vertical-align: middle;
	padding: 15px;
	color: #1e293b;
	border-bottom: 1px solid #f1f5f9;
}

.btn-action {
	border-radius: 8px;
	padding: 6px 12px;
}

/* BADGES */
.badge-status {
	padding: 6px 12px;
	border-radius: 20px;
	font-weight: 500;
}

/* RESPONSIVE FIXES */
@media ( max-width : 768px) {
	.sidebar {
		min-height: auto;
		padding: 10px;
	}
	.main {
		padding: 1rem;
	}
}

.logout-hover {
        transition: all 0.3s ease;
        padding: 10px;
        border-radius: 8px;
    }
    .logout-hover:hover {
        background-color: rgba(220, 53, 69, 0.1); /* Light red tint on hover */
        transform: translateX(5px);
    }
</style>
</head>

<body>

	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-2 col-md-3 sidebar shadow">
				<div class="sidebar-header text-center">
					<div class="mb-3">
						<i class="bi bi-shield-lock-fill text-success"
							style="font-size: 3rem;"></i>
					</div>
					<h6 class="fw-bold mb-0 text-white"><%=admin.getName()%></h6>
					<span class="badge bg-success mt-2" style="font-size: 0.7rem;">SYSTEM
						ADMIN</span>
				</div>

				<div class="mt-4">
					<a onclick="showSection('dashboard')" id="nav-dashboard"
						class="active"><i class="bi bi-grid-1x2-fill"></i> Dashboard</a> <a
						onclick="showSection('employers')" id="nav-employers"><i
						class="bi bi-building"></i> Employers</a> <a
						onclick="showSection('jobseekers')" id="nav-jobseekers"><i
						class="bi bi-people"></i> Seekers</a> <a onclick="showSection('jobs')"
						id="nav-jobs"><i class="bi bi-briefcase"></i> Job Posts</a> <a
						onclick="showSection('applications')" id="nav-applications"><i
						class="bi bi-file-earmark-check"></i> Applications</a>

					<hr class="mx-3 opacity-25">

					<div class="mt-auto pb-4 px-3">
						<hr class="opacity-25 text-white">
						<a href="LogoutServlet"
							class="nav-link text-danger d-flex align-items-center fw-bold logout-hover">
							<i class="bi bi-box-arrow-right fs-5 me-2"></i> <span>Logout</span>
						</a>
					</div>
				</div>
			</div>

			<div class="col-lg-10 col-md-9 main">

				<div id="dashboard-stats" class="row g-4 mb-4">
					<div class="col-6 col-lg-3">
						<div class="stat-card">
							<div class="text-muted small">Total Employers</div>
							<h3 class="fw-bold mb-0"><%=employers.size()%></h3>
						</div>
					</div>
					<div class="col-6 col-lg-3">
						<div class="stat-card">
							<div class="text-muted small">Job Seekers</div>
							<h3 class="fw-bold mb-0"><%=jobSeekers.size()%></h3>
						</div>
					</div>
					<div class="col-6 col-lg-3">
						<div class="stat-card">
							<div class="text-muted small">Active Jobs</div>
							<h3 class="fw-bold mb-0"><%=jobs.size()%></h3>
						</div>
					</div>
					<div class="col-6 col-lg-3">
						<div class="stat-card border-start border-4 border-success">
							<div class="text-muted small">Applications</div>
							<h3 class="fw-bold mb-0"><%=applications.size()%></h3>
						</div>
					</div>
				</div>

				<div class="table-card" id="dashboard" style="display: block;">
					<div class="py-5 text-center">
						<img src="https://illustrations.popsy.co/amber/manager.svg"
							alt="Admin" style="width: 200px;">
						<h2 class="fw-bold mt-4">
							Welcome back,
							<%=admin.getName()%>!
						</h2>
						<p class="text-muted">Manage your platform data using the
							sidebar navigation.</p>
					</div>
				</div>

				<div class="table-card" id="employers">
					<div class="d-flex justify-content-between align-items-center mb-4">
						<h5 class="fw-bold mb-0">
							<i class="bi bi-building me-2 text-primary"></i>Employers
							Management
						</h5>
						<button class="btn btn-primary shadow-sm" data-bs-toggle="modal"
							data-bs-target="#addEmployerModal">
							<i class="bi bi-plus-lg"></i> Add New
						</button>
					</div>
					<div class="table-responsive">
						<table class="table align-middle">
							<thead>
								<tr>
									<th>ID</th>
									<th>Company</th>
									<th>Email</th>
									<th>Location</th>
									<th class="text-end">Action</th>
								</tr>
							</thead>
							<tbody>
								<%
								for (Employer e : employers) {
								%>
								<tr>
									<td class="fw-bold text-muted">#<%=e.getEmployerId()%></td>
									<td><span class="fw-semibold"><%=e.getCompanyName()%></span></td>
									<td><%=e.getEmail()%></td>
									<td><i class="bi bi-geo-alt text-danger small"></i> <%=e.getLocation()%></td>
									<td class="text-end">
										<button class="btn btn-sm btn-outline-warning btn-action"
											onclick="fillEmployer('<%=e.getEmployerId()%>','<%=e.getCompanyName()%>','<%=e.getEmail()%>','<%=e.getLocation()%>')"
											data-bs-toggle="modal" data-bs-target="#editEmployerModal">Edit</button>
										<a href="DeleteEmployer?id=<%=e.getEmployerId()%>"
										class="btn btn-sm btn-outline-danger btn-action ms-1">Delete</a>
									</td>
								</tr>
								<%
								}
								%>
							</tbody>
						</table>
					</div>
				</div>

				<div class="table-card" id="jobseekers">
					<div class="d-flex justify-content-between align-items-center mb-4">
						<h5 class="fw-bold mb-0">
							<i class="bi bi-people me-2 text-primary"></i>Talent Pool
						</h5>
						<button class="btn btn-primary shadow-sm" data-bs-toggle="modal"
							data-bs-target="#addJobSeekerModal">
							<i class="bi bi-person-plus"></i> Register Seeker
						</button>
					</div>
					<div class="table-responsive">
						<table class="table align-middle">
							<thead>
								<tr>
									<th>ID</th>
									<th>Candidate</th>
									<th>Email</th>
									<th>Experience</th>
									<th>Location</th>
									<th class="text-end">Action</th>
								</tr>
							</thead>
							<tbody>
								<%
								for (JobSeeker js : jobSeekers) {
								%>
								<tr>
									<td>#<%=js.getJobSeekerId()%></td>
									<td><div class="fw-bold text-dark"><%=js.getName()%></div></td>
									<td><%=js.getEmail()%></td>
									<td><span class="badge bg-light text-dark border"><%=js.getExperienceYears()%>
											Years</span></td>
									<td><%=js.getLocation()%></td>
									<td class="text-end">
										<button class="btn btn-sm btn-outline-warning btn-action"
											onclick="fillJobSeeker('<%=js.getJobSeekerId()%>','<%=js.getName()%>','<%=js.getEmail()%>','<%=js.getExperienceYears()%>','<%=js.getLocation()%>')"
											data-bs-toggle="modal" data-bs-target="#editJobSeekerModal">Edit</button>
										<a href="DeleteJobSeeker?id=<%=js.getJobSeekerId()%>"
										class="btn btn-sm btn-outline-danger btn-action ms-1">Delete</a>
									</td>
								</tr>
								<%
								}
								%>
							</tbody>
						</table>
					</div>
				</div>

				<div class="table-card" id="jobs">
					<h5 class="fw-bold mb-4">
						<i class="bi bi-briefcase me-2 text-primary"></i>Live Vacancies
					</h5>
					<div class="table-responsive">
						<table class="table align-middle">
							<thead>
								<tr>
									<th>ID</th>
									<th>Job Title</th>
									<th>Location</th>
									<th>Min Sal</th>
									<th>Max Sal</th>
									<th class="text-end">Action</th>
								</tr>
							</thead>
							<tbody>
								<%
								for (Job ja : jobs) {
								%>
								<tr>
									<td>#<%=ja.getJobId()%></td>
									<td class="fw-bold text-primary"><%=ja.getTitle()%></td>
									<td><%=ja.getLocation()%></td>
									<td class="text-success">$<%=ja.getSalaryMin()%></td>
									<td class="text-success">$<%=ja.getSalaryMax()%></td>
									<td class="text-end"><a
										href="DeleteJob?id=<%=ja.getJobId()%>"
										class="btn btn-sm btn-danger btn-action">Remove</a></td>
								</tr>
								<%
								}
								%>
							</tbody>
						</table>
					</div>
				</div>

				<div class="table-card" id="applications">
					<h5 class="fw-bold mb-4">
						<i class="bi bi-file-earmark-text me-2 text-primary"></i>Recent
						Applications
					</h5>
					<div class="table-responsive">
						<table class="table align-middle">
							<thead>
								<tr>
									<th>ID</th>
									<th>Job ID</th>
									<th>Seeker ID</th>
									<th>Status</th>
									<th class="text-end">Action</th>
								</tr>
							</thead>
							<tbody>
								<%
								for (JobApplication ja : applications) {
								%>
								<tr>
									<td>#<%=ja.getApplicationId()%></td>
									<td>Job-<%=ja.getJobId()%></td>
									<td>Seek-<%=ja.getJobSeekerId()%></td>
									<td><span
										class="badge bg-info-subtle text-info badge-status"><%=ja.getApplicationStatus()%></span></td>
									<td class="text-end"><a
										href="DeleteApplication?id=<%=ja.getApplicationId()%>"
										class="btn btn-sm btn-danger btn-action">Remove</a></td>
								</tr>
								<%
								}
								%>
							</tbody>
						</table>
					</div>
				</div>

			</div>
		</div>
	</div>

	<div class="modal fade" id="addEmployerModal" tabindex="-1">
		<div class="modal-dialog modal-dialog-centered">
			<form class="modal-content border-0 shadow" action="AddEmployer"
				method="post">
				<div class="modal-header bg-primary text-white">
					<h5 class="modal-title fw-bold">Add Employer</h5>
					<button type="button" class="btn-close btn-close-white"
						data-bs-dismiss="modal"></button>
				</div>
				<div class="modal-body p-4">
					<div class="mb-3">
						<label class="form-label small fw-bold">Company Name</label> <input
							name="companyName" class="form-control"
							placeholder="Enter company name" required>
					</div>
					<div class="mb-3">
						<label class="form-label small fw-bold">Email Address</label> <input
							name="email" type="email" class="form-control"
							placeholder="email@company.com" required>
					</div>
					<div class="mb-3">
						<label class="form-label small fw-bold">Password</label> <input
							name="password" type="password" class="form-control" required>
					</div>
					<div class="mb-3">
						<label class="form-label small fw-bold">Office Location</label> <input
							name="location" class="form-control" placeholder="City, Country">
					</div>
				</div>
				<div class="modal-footer border-0">
					<button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
					<button class="btn btn-primary px-4">Register Employer</button>
				</div>
			</form>
		</div>
	</div>

	<div class="modal fade" id="editEmployerModal">
		<div class="modal-dialog modal-dialog-centered">
			<form class="modal-content border-0 shadow" action="EditEmployer"
				method="post">
				<input type="hidden" name="id" id="empId">
				<div class="modal-header bg-warning">
					<h5 class="modal-title fw-bold">Update Profile</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>
				<div class="modal-body p-4">
					<input id="empName" name="companyName" class="form-control mb-3"
						placeholder="Company Name"> <input id="empEmail"
						name="email" class="form-control mb-3" placeholder="Email">
					<input id="empLocation" name="location" class="form-control mb-3"
						placeholder="Location">
				</div>
				<div class="modal-footer border-0">
					<button class="btn btn-success w-100">Save Changes</button>
				</div>
			</form>
		</div>
	</div>

	<div class="modal fade" id="addJobSeekerModal">
		<div class="modal-dialog modal-dialog-centered">
			<form class="modal-content border-0 shadow" action="AddJobSeeker"
				method="post">
				<div class="modal-header bg-primary text-white">
					<h5 class="modal-title fw-bold">Register Candidate</h5>
					<button type="button" class="btn-close btn-close-white"
						data-bs-dismiss="modal"></button>
				</div>
				<div class="modal-body p-4">
					<input name="name" class="form-control mb-3" placeholder="Full Name" required> 
					<input name="email"	type="email" class="form-control mb-3" placeholder="Email" required> 
					
					<input name="password" type="password" class="form-control mb-3" placeholder="Create Password" required>
					
					<input name="experience" class="form-control mb-3" placeholder="Years of Experience"> 
					
					<input name="location" class="form-control mb-3" placeholder="Location">
				</div>
				<div class="modal-footer border-0">
					<button class="btn btn-primary w-100">Add Candidate</button>
				</div>
			</form>
		</div>
	</div>

	<div class="modal fade" id="editJobSeekerModal">
		<div class="modal-dialog modal-dialog-centered">
			<form class="modal-content border-0 shadow" action="EditJobSeeker"
				method="post">
				<input type="hidden" name="id" id="jsId">
				<div class="modal-header bg-warning">
					<h5 class="modal-title fw-bold">Edit Seeker Details</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>
				<div class="modal-body p-4">
					<input id="jsName" name="name" class="form-control mb-3"> <input
						id="jsEmail" name="email" class="form-control mb-3"> <input
						id="jsExp" name="experience" class="form-control mb-3"> <input
						id="jsLocation" name="location" class="form-control mb-3">
				</div>
				<div class="modal-footer border-0">
					<button class="btn btn-success w-100">Update Seeker</button>
				</div>
			</form>
		</div>
	</div>

	<script>
    function fillEmployer(id, name, email, location) {
        document.getElementById('empId').value = id;
        document.getElementById('empName').value = name;
        document.getElementById('empEmail').value = email;
        document.getElementById('empLocation').value = location;
    }

    function fillJobSeeker(id, name, email, exp, location) {
        document.getElementById('jsId').value = id;
        document.getElementById('jsName').value = name;
        document.getElementById('jsEmail').value = email;
        document.getElementById('jsExp').value = exp;
        document.getElementById('jsLocation').value = location;
    }

    function showSection(id) {
        // Hide all cards
        document.querySelectorAll('.table-card').forEach(div => {
            div.style.display = 'none';
        });
        
        // Show selected card
        document.getElementById(id).style.display = 'block';

        // Update Nav Active State
        document.querySelectorAll('.sidebar a').forEach(a => {
            a.classList.remove('active');
        });
        document.getElementById('nav-' + id).classList.add('active');

        // Toggle stats visibility (only show on main dashboard)
        const stats = document.getElementById('dashboard-stats');
        stats.style.display = (id === 'dashboard') ? 'flex' : 'none';
    }
</script>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>