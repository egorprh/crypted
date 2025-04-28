import React from 'react';
import { useNavigate, useOutletContext } from 'react-router-dom';
import './lesson.css';

export default function Lesson() {
    const { lesson, lessonId, courseId } = useOutletContext();
    const navigate = useNavigate();

    const clickNextBtn = () => {
        navigate(`/lessons/${courseId}/${lessonId}/materials`);
    };

    return (
        <div className="lesson-container">
            <div>
                {lesson.video_url && (
                    <div className="video-container">
                        <iframe
                            src={lesson.video_url}
                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                            allowFullScreen
                            title={lesson.title}
                        />
                    </div>
                )}

                <h2>{lesson.title}</h2>

                <div className="lesson-description" dangerouslySetInnerHTML={{ __html: lesson.description }} />
            </div>

            <button className="btn" onClick={clickNextBtn}>Далее</button>
        </div>
    );
}
