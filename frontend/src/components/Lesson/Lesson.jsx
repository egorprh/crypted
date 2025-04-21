import React from 'react';
import { useOutletContext } from 'react-router-dom';
import './lesson.css';

export default function Lesson() {
    const lesson = useOutletContext();

    return (
        <>
            {lesson.video_url && (
                <div className="video-container">
                    <iframe
                        src={lesson.video_url}
                        frameBorder="0"
                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                        allowFullScreen
                        title={lesson.title}
                    />
                </div>
            )}

            <div className="lesson-description">
                {lesson.description.split('\n').map((p, i) => <p key={i}>{p}</p>)}
            </div>
        </>
    );
}
