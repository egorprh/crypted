import React from 'react';
import { useNavigate, useOutletContext } from 'react-router-dom';
import './lesson.css';
import Button from "../ui/Button/Button.jsx";

export default function Lesson() {
    const { lesson, lessonId, courseId } = useOutletContext();
    const navigate = useNavigate();

    const clickNextBtn = () => {
        if (lesson.materials?.length > 0) {
            navigate(`/lessons/${courseId}/${lessonId}/materials`);
        } else if (lesson.quizzes?.length > 0) {
            navigate(`/lessons/${courseId}/${lessonId}/quiz`);
        }
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

            {(lesson.materials?.length > 0 || lesson.quizzes?.length > 0) && (
                <div className="lesson-footer">
                    <Button
                        type="btn-white btn-full-width"
                        text="Далее"
                        onClick={clickNextBtn}
                    />
                </div>
            )}
        </div>
    );
}
