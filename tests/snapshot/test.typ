#import "../../src/lib.typ": *

// Keep this regression fixture generic while exercising the public API.
#let name = "John Doe"
#let location = "Example City, EX"
#let email = "john.doe@example.com"
#let email-text = "john.doe@example.com"
#let github = "github.com/johndoe"
#let github-text = "johndoe"
#let linkedin = "linkedin.com/in/johndoe"
#let linkedin-text = "johndoe"
#let phone = "+1 (xxx) xxx-xxxx"
#let personal-site = "example.com"
#let personal-site-text = "example.com"

#show: resume.with(
  author: name,
  location: location,
  email: email,
  email-text: email-text,
  github: github,
  github-text: github-text,
  linkedin: linkedin,
  linkedin-text: linkedin-text,
  phone: phone,
  personal-site: personal-site,
  personal-site-text: personal-site-text,
  // Accent color is optional. Feel free to remove the next line if you want your resume to be in black and white
  accent-color: "#26428b",
  author-position: center,
  personal-info-position: center,
)

/*
 * Lines that start with == are formatted into section headings.
 * Available formatting functions include:
 * #summary(body)
 * #edu(dates: "", degree: "", gpa: "", institution: "", location: "", consistent: false)
 * #work(company: "", dates: "", location: "", title: "")
 * #project(name: "", technologies: "", links: ())
 * #certificates(name: "", issuer: "", url: "", url-text: "", date: "")
 * #extracurriculars(activity: "", dates: "")
 *
 * Generic layout helpers:
 * #generic-two-by-two(top-left: "", top-right: "", bottom-left: "", bottom-right: "")
 * #generic-one-by-two(left: "", right: "")
 * #dates-helper(start-date: "", end-date: "")
 * #edu-entry(year: "", institution: "", grade: "")
 * #linked-text(value, link-prefix: "", text: "")
 */
== Summary

#summary[Software engineer with experience building reliable services and internal tools. Focused on clear APIs, automated testing, and documentation.]

== Education

#edu(
  institution: "Example University",
  location: "Example City, EX",
  dates: dates-helper(start-date: "Aug 2020", end-date: "May 2024"),
  degree: "Bachelor of Science, Computer Science",
)
- GPA: 3.8/4.0 | Dean's List
- Relevant Coursework: Data Structures, Algorithms, Databases, Distributed Systems

== Work Experience

#work(
  title: "Software Engineer",
  location: "Example City, EX",
  company: "Example Corporation",
  dates: dates-helper(start-date: "Jun 2024", end-date: "Present"),
)
- Built reliable services and internal tools for a growing customer platform
- Improved deployment workflows and reduced routine release time by 40\%
- Collaborated with product and infrastructure teams to deliver measurable results

#work(
  title: "Engineering Intern",
  location: "Example City, EX",
  company: "Example Labs",
  dates: dates-helper(start-date: "Jun 2023", end-date: "Aug 2023"),
)
- Implemented product improvements with a focus on testing and maintainability
- Automated recurring analysis tasks and documented the resulting workflow

== Projects

#project(
  name: "Example Project",
  technologies: "Python, FastAPI, Redis",
  links: (
    (url: "github.com/johndoe/example-project", text: "Github"),
    (url: "example.com", text: "Live"),
  ),
)
- Built an open-source project with a clear API, automated tests, and documentation
- Designed the system to remain easy to extend as requirements change

== Certificates

#certificates(
  name: "Example Certification",
  issuer: "Example Institute",
  date: "Jun 2024",
  url: "example.com/cert",
  url-text: "Certificate",
)

== Activities

#extracurriculars(
  activity: "Example Open Source Group",
  dates: dates-helper(start-date: "Jan 2022", end-date: "Present"),
)
- Contributed documentation, bug fixes, and mentoring to a community project

== Skills
*Programming Languages*: Python, JavaScript, TypeScript, Java, SQL, Bash
*Technologies*: Git, Linux, Docker, PostgreSQL, React, REST APIs
