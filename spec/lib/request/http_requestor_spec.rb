##
# This file is part of IMS Caliper Analytics™ and is licensed to
# IMS Global Learning Consortium, Inc. (http://www.imsglobal.org)
# under one or more contributor license agreements.  See the NOTICE
# file distributed with this work for additional information.
#
# IMS Caliper is free software: you can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# IMS Caliper is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License along
# with this program. If not, see http://www.gnu.org/licenses/.

require 'require_all'
require_all 'lib/caliper/entities/entity.rb'
require_all 'lib/caliper/entities/agent/software_application.rb'
require_all 'lib/caliper/entities/agent/person.rb'
require_all 'lib/caliper/entities/lis/membership.rb'
require_all 'lib/caliper/entities/lis/roles.rb'
require_all 'lib/caliper/entities/lis/status.rb'
require_all 'lib/caliper/entities/lis/course_section.rb'
require_all 'lib/caliper/entities/lis/course_offering.rb'
require_all 'lib/caliper/entities/lis/group.rb'
require_all 'lib/caliper/entities/reading/epub_volume.rb'
require_all 'lib/caliper/entities/reading/web_page.rb'
require_all 'lib/caliper/event/navigation_event.rb'
require_all 'lib/caliper/profiles/reading_profile.rb'
require_all 'lib/caliper/options.rb'
require_all 'lib/caliper/sensor.rb'
require_all 'lib/caliper/request/http_requestor.rb'

require 'json_spec'

module Caliper
  module Request

    describe Envelope do

      it 'should ensure that a Caliper envelope comprising a NavigationEvent is correctly created and serialized' do

        # The Actor (Person/Student))
        student = Caliper::Entities::Agent::Person.new
        student.id = 'https://some-university.edu/user/554433'
        membership1 = Caliper::Entities::LIS::Membership.new
        membership1.id = "https://some-university.edu/membership/001"
        membership1.member = "https://some-university.edu/user/554433"
        membership1.organization = "https://some-university.edu/politicalScience/2015/american-revolution-101"
        membership1.roles = [Caliper::Entities::LIS::Roles::LEARNER]
        membership1.status = Caliper::Entities::LIS::Status::ACTIVE
        membership1.dateCreated = "2015-08-01T06:00:00.000Z"
        membership1.dateModified = nil;
        membership2 = Caliper::Entities::LIS::Membership.new
        membership2.id = "https://some-university.edu/membership/002"
        membership2.member = "https://some-university.edu/user/554433"
        membership2.organization = "https://some-university.edu/politicalScience/2015/american-revolution-101/section/001"
        membership2.roles = [Caliper::Entities::LIS::Roles::LEARNER]
        membership2.status = Caliper::Entities::LIS::Status::ACTIVE
        membership2.dateCreated = "2015-08-01T06:00:00.000Z"
        membership2.dateModified = nil
        membership3 = Caliper::Entities::LIS::Membership.new
        membership3.id = "https://some-university.edu/membership/003"
        membership3.member = "https://some-university.edu/user/554433"
        membership3.organization = "https://some-university.edu/politicalScience/2015/american-revolution-101/section/001/group/001"
        membership3.roles = [Caliper::Entities::LIS::Roles::LEARNER]
        membership3.status = Caliper::Entities::LIS::Status::ACTIVE
        membership3.dateCreated = "2015-08-01T06:00:00.000Z"
        membership3.dateModified = nil
        student.hasMembership = [membership1, membership2, membership3]
        student.dateCreated = '2015-08-01T06:00:00.000Z'
        student.dateModified = '2015-09-02T11:30:00.000Z'
        # puts "new student = #{student.to_json}"

        # The Action
        action = Caliper::Profiles::ProfileActions::NAVIGATED_TO

        # The Object navigated (ePub Volume)
        ePubVolume = Caliper::Entities::Reading::EPubVolume.new
        ePubVolume.id = 'https://github.com/readium/readium-js-viewer/book/34843#epubcfi(/4/3)'
        ePubVolume.name = 'The Glorious Cause: The American Revolution, 1763-1789 (Oxford History of the United States)'
        ePubVolume.version = '2nd ed.'
        ePubVolume.dateCreated = '2015-08-01T06:00:00.000Z'
        ePubVolume.dateModified = '2015-09-02T11:30:00.000Z'

        # The Target within the Object (frame)
        frame = Caliper::Entities::Reading::Frame.new
        frame.id = 'https://github.com/readium/readium-js-viewer/book/34843#epubcfi(/4/3/1)'
        frame.name = 'Key Figures: George Washington'
        frame.version = '2nd ed.'
        frame.dateCreated = '2015-08-01T06:00:00.000Z'
        frame.dateModified = '2015-09-02T11:30:00.000Z'
        frame.index = 1
        frame.isPartOf = ePubVolume.id

        # The course that is part of the Learning Context (edApp)
        edApp = Caliper::Entities::Agent::SoftwareApplication.new
        edApp.id = 'https://github.com/readium/readium-js-viewer'
        edApp.name = 'Readium'
        edApp.hasMembership = []
        edApp.dateCreated = '2015-08-01T06:00:00.000Z'
        edApp.dateModified = '2015-09-02T11:30:00.000Z'

        #LIS Course Offering
        courseOffering = Caliper::Entities::LIS::CourseOffering.new
        courseOffering.id = "https://some-university.edu/politicalScience/2015/american-revolution-101"
        courseOffering.name = "Political Science 101: The American Revolution"
        courseOffering.courseNumber = "POL101"
        courseOffering.academicSession = "Fall-2015"
        courseOffering.membership = []
        courseOffering.subOrganizationOf = nil
        courseOffering.dateCreated = '2015-08-01T06:00:00.000Z'
        courseOffering.dateModified = '2015-09-02T11:30:00.000Z'

        # The LIS Course Section for the Caliper Event
        course = Caliper::Entities::LIS::CourseSection.new
        course.id = 'https://some-university.edu/politicalScience/2015/american-revolution-101/section/001'
        course.name = 'American Revolution 101'
        course.courseNumber = "POL101"
        course.academicSession = "Fall-2015"
        course.category = nil
        course.membership = [membership2]
        course.subOrganizationOf = courseOffering
        course.dateCreated = '2015-08-01T06:00:00.000Z'
        course.dateModified = '2015-09-02T11:30:00.000Z'

        # LIS Group
        group = Caliper::Entities::LIS::Group.new
        group.id = "https://some-university.edu/politicalScience/2015/american-revolution-101/section/001/group/001"
        group.name = "Discussion Group 001"
        group.membership = [membership3]
        group.subOrganizationOf = course
        group.dateCreated = '2015-08-01T06:00:00.000Z'
        group.dateModified = nil

        # The navigatedFrom property (specific to Navigation Event)
        fromPage = Caliper::Entities::Reading::WebPage.new
        fromPage.id = 'https://some-university.edu/politicalScience/2015/american-revolution-101/index.html'
        fromPage.name = 'American Revolution 101 Landing Page'
        fromPage.dateCreated = '2015-08-01T06:00:00.000Z'
        fromPage.dateModified = '2015-09-02T11:30:00.000Z'
        fromPage.isPartOf = nil
        fromPage.version = '1.0'

        # The (Reading::BookmarkReading) Event
        navigated_event = Caliper::Event::NavigationEvent.new
        navigated_event.actor  = student
        navigated_event.action = action
        navigated_event.object = ePubVolume
        navigated_event.target = frame
        navigated_event.generated = nil
        navigated_event.edApp  = edApp
        navigated_event.group = group
        navigated_event.navigatedFrom = fromPage
        navigated_event.startedAtTime = '2015-09-15T10:15:00.000Z'
        navigated_event.endedAtTime = nil
        navigated_event.duration = nil
        # puts "Event JSON = #{navigated_event.to_json}'"

        # The Sensor
        options = Caliper::Options.new
        sensor = Caliper::Sensor.new("http://learning-app.some-university.edu/sensor", options)
        requestor = Caliper::Request::HttpRequestor.new(options)
        json_payload = requestor.generate_payload(sensor, navigated_event)

        # Swap out sendTime=DateTime.now() in favor of fixture value (or test will most assuredly fail).
        json_payload_sub = json_payload.sub(/\"sendTime\":\"[^\"]*\"/, "\"sendTime\":\"2015-09-15T11:05:01.000Z\"")

        # Load JSON from caliper-common-fixtures for comparison
        # NOTE - sym link to caliper-common-fixtures needs to exist under spec/fixtures
        file = File.read('spec/fixtures/eventStorePayload.json')
        data_hash = JSON.parse(file)
        expected_json = data_hash.to_json # convert hash back to JSON string after parse
        json_payload_sub.should be_json_eql(expected_json)

        # puts "JSON from file = #{data_hash}"
        # deser_envelope = Caliper::Request::Envelope.new
        # deser_envelope.from_json data_hash
        # puts "Envelope from JSON = #{deser_envelope.to_json}"

        # Ensure that the deserialized shared event object conforms
        # expect(json_payload_sub).to eql(deser_envelope)
      end
    end
  end
end