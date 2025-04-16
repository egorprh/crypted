import React from "react";
import "./calendar.css";

export default function Calendar() {
  const events = [
    {
      title: "Стрим. (тема стрима)",
      date: "22.02.2025",
      author: "vyshee",
      image: "/event-image.jpg", // Подставь путь к изображению
    },
  ];

  return (
    <div className="page-container">
      <div className="header">
        <img src="/logo.svg" alt="DeptSpace" />
      </div>

      <div className="content">
        <h2 className="title">Ближайшие ивенты</h2>

        {events.map((event, i) => (
          <div key={i} className="event-card">
            <img src={event.image} alt="Event preview" className="event-image" />

            <div className="event-info">
              <div>
                <p className="event-title">{event.title}</p>
                <p className="event-author">by {event.author}</p>
              </div>
              <span className="event-date">{event.date}</span>
            </div>
          </div>
        ))}
      </div>

    </div>
  );
}
