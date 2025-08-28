import React from 'react';
import { useNavigate, useOutletContext } from 'react-router-dom';
import './lesson.css';
import Button from "../ui/Button/Button.jsx";

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

                {lesson.source_url && lesson.source_url.trim() && <div className="source_url_link">Если видео не запускается перейдите по <a target="_blank" href={lesson.source_url}>ссылке</a></div>}

                <h2>{lesson.title}</h2>

                <div className="lesson-description" dangerouslySetInnerHTML={{ __html: lesson.description }} />
            </div>
        </div>
    );
}
