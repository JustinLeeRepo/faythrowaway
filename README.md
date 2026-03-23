## Hey Hey Fay Ole  





https://github.com/user-attachments/assets/9b8ef25b-0b19-4cf3-a10a-ed7b0758ade3

There is a a loading state that utilizes placeholders, an empty state, an error state, and a ready state when the appointments are fetched.

Auth Tokens are stored in the keychain.

# Implementation Notes / Decisions
Tried to keep components separated and as small as possible

Utilizes reusable remote SPM packages (networking and keychain).

Breaks down code base into local SPM packages (depedencyContainer, unauthorized feature, authorized feature, and services [the local SPM package, services, consumes reusable remote spm packages: keychain and network client])


# Login & Auth
4-5 hours (coming back from dropping dog off at vet and running errands, then eating dinner, getting a little distracted around midnight with live streams)

# Appointments 
7 - 9 hours (lost count after staying up all night and then going to pick my dog up from the vet in the morning)

# Instructions
# Fay iOS project

We'd like to see what you can build. You'll be implementing a simple iOS app in Swift that interfaces with a service we built specifically for this exercise (documented at the bottom of this page).

Since we don't have a full spec, we'd like you to make small judgment calls on your own.

Here’s what the work entails:

## A simple login screen with email and password

There’s no design for this so just make your own! It should authenticate the sole user specified in the documentation and not accept any other credentials. Successful login leads to the “Appointments overview” screen below.

## An “Appointments overview” screen

Please see the design below, and also linked in this. Icons, text etc are available in the figma design: https://www.figma.com/design/Xa6fdpXyq7EDZPcX3CHgN0/%F0%9F%93%B1-Fay-iOS-project?node-id=0-1&t=QOqxYs3PDgBZ09wL-1 

![home1](https://github.com/user-attachments/assets/fe9e4e8d-effa-4849-93f6-9577739c1376)

![home2](https://github.com/user-attachments/assets/aa8b5ffb-c4df-49fd-a259-cbf2d2019ce2)

**Note:**

- The information on this screen should be populated with data from the service
- The service provides appointment information but not provider metadata, so you can assume the provider’s name is “Jane Williams”
- Only the first appointment card in “Upcoming” appointment tab will have “Join appointment” button
    - The “Join appointment” button should not do anything
- Ensure the timezone adapts to the user’s current time zone
- Chat, Journal and Profile tabs have no content in them. Bonus points if you make the tabs work.

## Nice to haves

We welcome any flourishes or enhancements you’d like to add. It could be anything from unit testing to a UI delighter. Feel free to get creative and upgrade the code or user experience in any way(s) you see fit!

## Deliverables

What are we looking for you to submit?

- Push your code to a public GitHub repo
- Include in your README:
    - A 1-3 minute video demo (Loom, YouTube unlisted, etc.)
    - Any implementation notes or decisions you made
    - Time breakdown:
        - Login screen: X hours
        - Appointments screen: X hours
        - Nice-to-haves: X hours
        - Any additional time spent: X hours
- Submit your repo link: [https://docs.google.com/forms/d/e/1FAIpQLSewN6jAR17El29BZJPL99VmUZ-HI-ClGoNyIjGlSPYpywv9vg/viewform?usp=header](https://docs.google.com/forms/d/e/1FAIpQLSewN6jAR17El29BZJPL99VmUZ-HI-ClGoNyIjGlSPYpywv9vg/viewform?usp=header)

* This is *not* a timed test, but knowing how much time you spent on different parts of the exercise is helpful context for us when reviewing your submission

## Final note

Have fun with this! Make this toy app your baby! Flex your style for building iOS apps! We look forward to checking out what you come up with.

# Service documentation

## API specifications

### Root URL

`https://node-api-for-candidates.onrender.com`

### Routes

`POST /signin`

Requires a JSON body containing a valid `username` and `password`:

```json
{
  username: "john",
  password: "12345"
}
```

Please note that other `username` and `password` combinations will return a `401`.

Returns a JWT token:

```json
{
  "token": ""
}
```

`GET /appointments`

Requires a valid `Authorization` header, in the format `Bearer {token}`.

Returns a list of appointments:

```json
{
    "appointments": [
        {
            "appointment_id": "509teq10vh",
            "patient_id": "1",
            "provider_id": "100",
            "status": "Scheduled",
            "appointment_type": "Follow-up",
            "start": "2024-08-10T17:45:00Z",
            "end": "2024-08-10T18:30:00Z",
            "duration_in_minutes": 45,
            "recurrence_type": "Weekly"
        },
        ...
    ]
}
```

## **Service idling**

Please note that the service will idle if not accessed for an extended period of time. The first response after extended idle time will be significantly slower than normal.


## **Service Disruption**

```json
{
  "appointments": [
    {
      "appointment_id": "mzdqmf1786",
      "patient_id": "1",
      "provider_id": "100",
      "status": "Scheduled",
      "appointment_type": "Follow-up",
      "start": "2025-01-27T17:45:00Z",
      "end": "2025-01-27T18:30:00Z",
      "duration_in_minutes": 45,
      "recurrence_type": "Weekly"
    },
    {
      "appointment_id": "dcb02amiu9",
      "patient_id": "1",
      "provider_id": "100",
      "status": "Scheduled",
      "appointment_type": "Follow-up",
      "start": "2025-06-20T11:00:00Z",
      "end": "2025-06-20T12:00:00Z",
      "duration_in_minutes": 60,
      "recurrence_type": "Weekly"
    },
    {
      "appointment_id": "cjy7yp7nm5",
      "patient_id": "1",
      "provider_id": "100",
      "status": "Scheduled",
      "appointment_type": "Follow-up",
      "start": "2025-08-10T10:45:00Z",
      "end": "2025-08-10T11:30:00Z",
      "duration_in_minutes": 45,
      "recurrence_type": "Weekly"
    },
    {
      "appointment_id": "n30kl8mpvo",
      "patient_id": "1",
      "provider_id": "100",
      "status": "Scheduled",
      "appointment_type": "Follow-up",
      "start": "2025-08-15T11:45:00Z",
      "end": "2025-08-15T12:30:00Z",
      "duration_in_minutes": 45,
      "recurrence_type": "Weekly"
    },
    {
      "appointment_id": "509teq10vh",
      "patient_id": "1",
      "provider_id": "100",
      "status": "Scheduled",
      "appointment_type": "Follow-up",
      "start": "2025-10-10T17:45:00Z",
      "end": "2025-10-10T18:30:00Z",
      "duration_in_minutes": 45,
      "recurrence_type": "Weekly"
    },
    {
      "appointment_id": "fkvedohjev",
      "patient_id": "1",
      "provider_id": "100",
      "status": "Scheduled",
      "appointment_type": "Follow-up",
      "start": "2025-12-11T20:00:00Z",
      "end": "2025-12-11T21:00:00Z",
      "duration_in_minutes": 60,
      "recurrence_type": "Weekly"
    },
    {
      "appointment_id": "v7y0i184hf",
      "patient_id": "1",
      "provider_id": "100",
      "status": "Scheduled",
      "appointment_type": "Follow-up",
      "start": "2025-12-15T17:00:00Z",
      "end": "2025-12-15T18:00:00Z",
      "duration_in_minutes": 60,
      "recurrence_type": "Weekly"
    },
    {
      "appointment_id": "uarlir2drj",
      "patient_id": "1",
      "provider_id": "100",
      "status": "Scheduled",
      "appointment_type": "Follow-up",
      "start": "2025-12-19T20:00:00Z",
      "end": "2025-12-19T21:00:00Z",
      "duration_in_minutes": 60,
      "recurrence_type": "Weekly"
    },
    {
      "appointment_id": "q4n8sk2wlp",
      "patient_id": "1",
      "provider_id": "100",
      "status": "Scheduled",
      "appointment_type": "Follow-up",
      "start": "2026-09-18T15:00:00Z",
      "end": "2026-09-18T15:45:00Z",
      "duration_in_minutes": 45,
      "recurrence_type": "Monthly"
    },
    {
      "appointment_id": "h2bz9mxd3q",
      "patient_id": "1",
      "provider_id": "100",
      "status": "Scheduled",
      "appointment_type": "Follow-up",
      "start": "2026-10-23T16:30:00Z",
      "end": "2026-10-23T17:30:00Z",
      "duration_in_minutes": 60,
      "recurrence_type": "Monthly"
    },
    {
      "appointment_id": "r8ty6vk1nc",
      "patient_id": "1",
      "provider_id": "100",
      "status": "Scheduled",
      "appointment_type": "Follow-up",
      "start": "2026-11-20T14:15:00Z",
      "end": "2026-11-20T15:00:00Z",
      "duration_in_minutes": 45,
      "recurrence_type": "Monthly"
    },
    {
      "appointment_id": "p6ld0we4zs",
      "patient_id": "1",
      "provider_id": "100",
      "status": "Scheduled",
      "appointment_type": "Follow-up",
      "start": "2026-12-18T18:00:00Z",
      "end": "2026-12-18T18:30:00Z",
      "duration_in_minutes": 30,
      "recurrence_type": "Monthly"
    },
    {
      "appointment_id": "a9xdflac00",
      "patient_id": "1",
      "provider_id": "100",
      "status": "Occurred",
      "appointment_type": "Follow-up",
      "start": "2024-09-10T17:45:00Z",
      "end": "2024-09-10T18:30:00Z",
      "duration_in_minutes": 45,
      "recurrence_type": "Monthly"
    },
    {
      "appointment_id": "x1r16i380u",
      "patient_id": "1",
      "provider_id": "100",
      "status": "Occurred",
      "appointment_type": "Initial consultation",
      "start": "2024-05-28T20:00:00Z",
      "end": "2024-05-28T21:00:00Z",
      "duration_in_minutes": 60,
      "recurrence_type": "Weekly"
    }
  ]
}
```

for request
```
curl -X GET "https://node-api-for-candidates.onrender.com/appointments" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiYWdlIjo0MiwibmFtZSI6IkpvaG4gRG9lIiwidXNlcm5hbWUiOiJqb2huIiwicGFzc3dvcmQiOiIxMjM0NSIsImlhdCI6MTc3NDAwMjk4OH0.FNy6LMQBfIkz1fP1Sx-DYoKY28HFaP2EQiTbOcBvp1o"
```
