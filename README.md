# DonAte
mobile programming project
GitHub link:
https://github.com/202304859/DonAte.git


202304859 Zahra Mohamed
202305120 Zahra Almosawi
202200879 Noor Mohammed
202204157 Maryam Azbeel
202300900 Fatema Almajed

Design changes
Donor GUI
Fatema Almajed(Donor login/ donor search):
tester - 202304859
1. Added logout button in donor profile 
2. ⁠added biometric authentication row in donor profile 
3. ⁠added delete button in edit donor address page

 Additional features: 202300900 fatema almajed
1. Export donor impact summary page to shareable pdf
2. ⁠biometric authentication upon login

Zahra Mohamed(Donor dashboard and notifications/ donate form):
tester - Fatema Almajed 202300900
Features are 90% incomplete both in code and design
there is no header or logo

1.dashboard is completely different as it is not completed

2.Notifications has not been implemented as it is still an empty view controller

3.Donate form only has the 3 view controllers with somewhat completed design but with minimal changes as the other has three dots next to it and all button titles are closer to their checkboxes

nothing else resembles the design as it was not done or implemented


Admin:
Zahra Almosawi(Admin user management/ Admin donation management)
tester - 202200879 noor mohamed
1. In the admin user management in the activity section the segmentation bar was not applied and the recent activity in the activity mode of the filter at the top was not implemented due to it being not useful and those activites can be tracked in the notification so functionally it's mostly useless but the session log actvity is there.

2. The filter modal after clicking on the filter is not implemented to each section in both features.

3. In the admin donation feature I added a button that leads the the all donations and appending and in this page the filter of all and pending approvals is still the same I its an extra thing I added to help with navigation, the donation details was not applied so it is basically missing but everything else in the design of this feature stayed the same.

4. No fire base integration it's just design and even the design is not completed.


Collector:
Noor Mohammed(login and regiester for collector / profile for collector):
tester - 202204157 Maryam Azbeel
1.    Login Page
    •    The curved header design was removed and replaced with a straight header line.
    •    The logo position was slightly adjusted and moved downward instead of being placed at the top of the header.
    2.    Register Page & Upload Verification Document Page
    •    The curved header was removed and replaced with a straight header line.
    •    The logo was removed from the header on both pages.
    3.    Registration Flow
    •    The registration flow was modified. After completing the first registration page, the Upload Verification Document page appears, followed by the Create Account page.
    4.    Text Fields Design
    •    Labels were placed inside the text fields instead of outside.
    •    Icons were added inside the text fields to improve clarity and usability.
    5.    Register Page Information
    •    Some of the information that users were originally required to fill in on the registration page was removed in the final implementation to simplify the registration process.
    6.    Profile Page
    •    Minor design changes were made to the profile page compared to the prototype.

Maryam Azbeel(Browse, Accept Donations & Update Status/Messaging & Communication):
tester - 202305120 zahra almosawi
    1.    The Xcode implementation focused on real application behavior, not just visual representation as shown in Figma.
    2.    Navigation was adjusted to support the actual user flow, including updating the navigation bar to prioritize notifications instead of profile access.
    3.    Headings were modified to better match mobile hierarchy and improve overall screen clarity.
    4.    The curved header design was removed and replaced with a straight header line to better suit real mobile implementation and improve layout consistency.
    5.    Several screens and UI components were enhanced, adapted, or simplified during implementation to support interaction and decision-making, ensure usability and consistency, and align with practical constraints and real mobile app usage.
    6.    The request card was enhanced to display more important details and allow direct actions such as accepting a request.
    7.    Regular contributors shown in the app are already accepted and have been working with the organization for some time. Currently, there are no new regular contributor requests.
    8.    Since regular contributors were accepted in the past and are part of ongoing collaboration, there are no newly accepted requests to display.
    9.    The contributor request screen was included in the Figma design but was not implemented in Xcode because regular contributors were already accepted earlier, and there are no new contributor requests that require approval.
    10.    The collector can update the donation status and message the donor from two different screens: the Accepted Donations screen and the Calendar (Pickups) screen. This allows easier access and faster communication, as accepted donation cards appear in both sections.
    11.    The profile image and previous donations section were removed from the contributor details screen to keep the focus on contribution summary only.
    12.    Messaging was simplified to text-only communication using top categories (All, Admin, Donor). Media sharing and advanced filters were removed, and proof of donation pickup and delivery is handled through the donation status update flow instead of chat media.
