<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.Model.*"%>
<%@ page
	import="com.DAO.JobDAO,com.DAO.JobApplicationDAO,com.DAO.JobSeekerDAO,com.DAO.SkillDAO"%>

<%
Employer employer = (Employer) session.getAttribute("employer");
if (employer == null) {
	response.sendRedirect("login.jsp");
	return;
}

session.setAttribute("userId", employer.getEmployerId());

JobDAO jobDao = new JobDAO();
JobApplicationDAO appDao = new JobApplicationDAO();
JobSeekerDAO jsDao = new JobSeekerDAO();
SkillDAO skillDao = new SkillDAO();

List<Skill> allSkills = skillDao.getAllSkills();
pageContext.setAttribute("allSkills", allSkills);
List<Job> jobs = jobDao.getJobsByEmployer(employer.getEmployerId());
List<JobApplication> applications = appDao.getApplicationsByEmployer(employer.getEmployerId());
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Employer Dashboard | <%=employer.getCompanyName()%></title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">
<link
	href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css"
	rel="stylesheet" />
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" />
<style>
:root {
	--primary-blue: #0a66c2;
	--light-bg: #f3f2ef;
	--success-green: #057642;
}

body {
	background: var(--light-bg);
	font-family: 'Inter', sans-serif;
	color: #1d1d1d;
}

/* NAVBAR */
.navbar {
	background: #ffffff !important;
	border-bottom: 1px solid #e0e0e0;
	padding: 0.75rem 1.5rem;
}

.navbar-brand {
	color: var(--primary-blue) !important;
	font-weight: 700;
}

/* SIDEBAR */
.sidebar {
	background: white;
	min-height: calc(100vh - 62px);
	padding: 30px 20px;
	border-right: 1px solid #e0e0e0;
}

/* CARDS */
.card {
	border: none;
	border-radius: 10px;
	transition: transform 0.2s, box-shadow 0.2s;
	box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.08);
}

.card:hover {
	transform: translateY(-3px);
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
}

.job-title {
	color: var(--primary-blue);
	font-weight: 600;
	font-size: 1.1rem;
}

.stat-box {
	background: #f8f9fa;
	border-radius: 8px;
	padding: 15px;
	margin-bottom: 15px;
	border-left: 4px solid var(--primary-blue);
}

/* Container to allow horizontal scrolling */
.job-scroll-wrapper {
	display: flex;
	overflow-x: auto;
	gap: 1.5rem;
	padding: 10px 5px 20px 5px;
	scrollbar-width: thin; /* For Firefox */
}

/* Custom Scrollbar for Chrome/Edge/Safari */
.job-scroll-wrapper::-webkit-scrollbar {
	height: 8px;
}

.job-scroll-wrapper::-webkit-scrollbar-thumb {
	background: #cbd5e0;
	border-radius: 10px;
}

/* Ensure cards don't shrink */
.job-card-flex {
	flex: 0 0 400px; /* Fixed width for each job card */
}

/* TABLE */
.table-container {
	background: white;
	padding: 20px;
	border-radius: 10px;
	box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.08);
}

.badge-open {
	background: #e7f6ed;
	color: #057642;
	border: 1px solid #057642;
}

.badge-closed {
	background: #fdf2f2;
	color: #c81e1e;
	border: 1px solid #c81e1e;
}

.logout-link {
	transition: all 0.3s ease;
	text-decoration: none;
}

.logout-link:hover {
	background-color: rgba(220, 53, 69, 0.1);
	border-radius: 5px;
}

.select2-container--bootstrap-5 .select2-selection {
	min-height: 38px;
	border: 1px solid #dee2e6;
}

@media ( max-width : 768px) {
	.sidebar {
		min-height: auto;
		border-right: none;
		border-bottom: 1px solid #ddd;
	}
}
</style>
</head>

<body>

	<nav class="navbar navbar-expand-lg sticky-top">
		<div class="container-fluid">
			<span class="navbar-brand"> <i
				class="bi bi-briefcase-fill me-2"></i> <%=employer.getCompanyName()%>
				Portal
			</span>
			<div class="d-flex align-items-center">
				<span class="me-3 d-none d-md-inline text-muted small">Welcome,
					Admin</span> <a href="LogoutServlet"
					class="btn btn-outline-danger btn-sm logout-link"> <i
					class="bi bi-box-arrow-right me-1"></i> Logout
				</a>
			</div>
		</div>
	</nav>

	<div class="container-fluid">
		<div class="row">

			<div class="col-md-3 sidebar">
				<button class="btn btn-primary w-100 mb-4 py-2 fw-bold shadow-sm"
					data-bs-toggle="modal" data-bs-target="#addJobModal">
					<i class="bi bi-plus-lg me-2"></i> POST A NEW JOB
				</button>

				<h6 class="text-uppercase fw-bold text-muted small mb-3">Dashboard
					Summary</h6>
				<div class="stat-box">
					<div class="small text-muted">Active Listings</div>
					<h4 class="mb-0 fw-bold"><%=jobs.size()%></h4>
				</div>
				<div class="stat-box" style="border-left-color: #6366f1;">
					<div class="small text-muted">Total Applications</div>
					<h4 class="mb-0 fw-bold text-indigo"><%=applications.size()%></h4>
				</div>

				<div class="mt-4 p-3 bg-light rounded small">
					<i class="bi bi-info-circle me-1"></i> Need help? Contact Support
					at <b>support@careerhub.com</b>
				</div>
			</div>

			<div class="col-md-9 p-lg-4 p-3">

				<div class="d-flex justify-content-between align-items-center mb-3">
					<h5 class="fw-bold m-0 text-dark">Your Job Postings</h5>
					<span class="badge bg-secondary rounded-pill"><%=jobs.size()%>
						Total</span>
				</div>

				<div class="row job-scroll-wrapper">
					<%
					for (Job j : jobs) {
					%>
					<div class="col-lg-6 mb-4 job-card-flex">
						<div class="card h-100">
							<div class="card-body">
								<div
									class="d-flex justify-content-between align-items-start mb-2">
									<h6 class="job-title mb-0"><%=j.getTitle()%></h6>
									<span
										class="badge <%=j.getStatus().equals("OPEN") ? "badge-open" : "badge-closed"%> px-2 py-1">
										<%=j.getStatus()%>
									</span>
								</div>
								<div class="text-muted small mb-3">
									<i class="bi bi-hash"></i> Job ID:
									<%=j.getJobId()%>
									| <i class="bi bi-geo-alt"></i>
									<%=j.getLocation()%>
								</div>
								<div class="fw-bold text-dark mb-3">
									<i class="bi bi-currency-rupee"></i>
									<%=j.getSalaryMin()%>
									-
									<%=j.getSalaryMax()%>
								</div>

								<div class="d-grid">
									<a
										href="UpdateJobStatusServlet?id=<%=j.getJobId()%>&status=<%=j.getStatus().equals("OPEN") ? "CLOSED" : "OPEN"%>"
										class="btn btn-sm <%=j.getStatus().equals("OPEN") ? "btn-outline-danger" : "btn-outline-success"%> fw-semibold">
										<i
										class="bi <%=j.getStatus().equals("OPEN") ? "bi-x-circle" : "bi-check-circle"%> me-1"></i>
										<%=j.getStatus().equals("OPEN") ? "Deactivate Job" : "Reactivate Job"%>
									</a>
								</div>
							</div>
						</div>
					</div>
					<%
					}
					%>
				</div>

				<hr class="my-4 opacity-25">

				<h5 class="fw-bold mb-3 text-dark">Recent Applications</h5>
				<div class="table-container">
					<div class="table-responsive">
						<table id="applicationsTable"
							class="table table-hover align-middle">
							<thead>
								<tr class="text-muted small text-uppercase">
									<th>ID</th>
									<th>Job ID</th>
									<th>Applicant Details</th>
									<th>Current Status</th>
									<th class="text-center">Manage</th>
								</tr>
							</thead>
							<tbody>
								<%
								for (JobApplication a : applications) {
									JobSeeker js = jsDao.getJobSeekerById(a.getJobSeekerId());
									if (js == null)
										continue;
								%>
								<tr>
									<td class="fw-bold text-muted">#<%=a.getApplicationId()%></td>
									<td><span class="badge bg-light text-dark">JB-<%=a.getJobId()%></span></td>
									<td>
										<div class="fw-bold text-dark"><%=js.getName()%></div>
										<div class="small text-muted"><%=js.getEmail()%></div> <a
										href="ViewJobSeekerServlet?id=<%=js.getJobSeekerId()%>"
										class="btn btn-link p-0 small text-decoration-none"> View
											Profile <i class="bi bi-arrow-right small"></i>
									</a>
									</td>
									<td><span
										class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 rounded-pill">
											<%=a.getApplicationStatus()%>
									</span></td>
									<td class="text-center">
										<div class="btn-group shadow-sm">
											<a
												href="UpdateApplicationStatusServlet?id=<%=a.getApplicationId()%>&status=SHORTLISTED"
												class="btn btn-sm btn-success" title="Shortlist"> <i
												class="bi bi-check-lg"></i>
											</a> <a
												href="UpdateApplicationStatusServlet?id=<%=a.getApplicationId()%>&status=REJECTED"
												class="btn btn-sm btn-danger" title="Reject"> <i
												class="bi bi-trash"></i>
											</a>
										</div>
									</td>
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

	<div class="modal fade" id="addJobModal" tabindex="-1">
		<div class="modal-dialog modal-dialog-centered">
			<form class="modal-content border-0 shadow-lg" action="AddJobServlet"
				method="post">
				<div class="modal-header bg-primary text-white">
					<h5 class="modal-title fw-bold">
						<i class="bi bi-pencil-square me-2"></i> Create New Listing
					</h5>
					<button type="button" class="btn-close btn-close-white"
						data-bs-dismiss="modal"></button>
				</div>
				<div class="modal-body p-4">
					<div class="mb-3">
						<label class="form-label fw-semibold small">Job Title</label> <input
							name="title" class="form-control"
							placeholder="e.g. Senior Software Engineer" required>
					</div>
					<div class="mb-3">
						<label class="form-label fw-semibold small">Work Location</label>
						<input name="location" class="form-control"
							placeholder="e.g. Bangalore, Remote" required>
					</div>
					<div class="mb-3">
						<label class="form-label fw-semibold small">Job
							Description</label>
						<textarea name="description" class="form-control" rows="3"
							placeholder="Briefly describe the role..."></textarea>
					</div>
					<div class="mb-3">
						<label class="form-label fw-semibold small">Required
							Skills</label> <select name="skills" class="form-select select2-skills"
							multiple="multiple" data-placeholder="Choose skills..." required>
							<%
							List<Skill> skills = (List<Skill>) pageContext.getAttribute("allSkills");
							if (skills != null) {
								for (Skill s : skills) {
							%>
							<option value="<%=s.getSkillId()%>"><%=s.getSkillName()%></option>
							<%
							}
							}
							%>
						</select>
					</div>
					<div class="row">
						<div class="col-md-6 mb-3">
							<label class="form-label fw-semibold small">Min Salary
								(Annual)</label> <input name="salaryMin" type="number"
								class="form-control" placeholder="₹" required>
						</div>
						<div class="col-md-6 mb-3">
							<label class="form-label fw-semibold small">Max Salary
								(Annual)</label> <input name="salaryMax" type="number"
								class="form-control" placeholder="₹" required>
						</div>
					</div>
				</div>
				<div class="modal-footer border-0">
					<button type="button" class="btn btn-light" data-bs-dismiss="modal">Discard</button>
					<button class="btn btn-primary px-4 fw-bold">Post Job Now</button>
				</div>
			</form>
		</div>
	</div>


	<div class="card mb-4 mt-2">
		<div class="card-body p-4">
			<div class="d-flex align-items-center mb-3">
				<i class="bi bi-diagram-3 text-primary fs-4 me-2"></i>
				<h6 class="fw-bold m-0 text-dark">Hiring Pipeline Overview</h6>
			</div>
			<div
				class="text-center overflow-hidden rounded-3 bg-white p-2 border">
				<img src="Assets/WorkFlow1.png" alt="Recruitment Workflow"
					class="img-fluid"
					style="max-height: 250px; width: auto; opacity: 0.9;">
			</div>
		</div>
	</div>


	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
	<script
		src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
	<script
		src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>

	<script>
		$(document).ready(function() {
			$('#applicationsTable').DataTable({
				"pageLength" : 5, // Show 5 applications per page
				"lengthMenu" : [ 5, 10, 25, 50 ],
				"language" : {
					"search" : "_INPUT_",
					"searchPlaceholder" : "Search applicants..."
				}
			});
		});
	</script>
	<script
		src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
	<script>
		$(document).ready(function() {
			$('.select2-skills').select2({
				theme : "bootstrap-5",
				dropdownParent : $('#addJobModal'), // Critical for modal focus
				placeholder : "Select skills",
				allowClear : true,
				closeOnSelect : false
			});
		});
	</script>
</body>
</html>