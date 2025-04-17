import React from 'react';
export default function ArrowIcon() {
    return (

        <svg
            xmlns="http://www.w3.org/2000/svg"
            xmlnsXlink="http://www.w3.org/1999/xlink"
            width={35}
            height={35}
            fill="none"
        >
            <path
                fill="url(#arrow)"
                d="M35 35h35v35H35z"
                transform="rotate(-180 35 35)"
            />
            <defs>
                <pattern
                    id="arrow"
                    width={1}
                    height={1}
                    patternContentUnits="objectBoundingBox"
                >
                    <use xlinkHref="#arrowb" transform="scale(.00195)"/>
                </pattern>
                <image
                    xlinkHref="data:image/png;base64,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"
                    id="arrowb"
                    width={512}
                    height={512}
                    preserveAspectRatio="none"
                />
            </defs>
        </svg>
    );
}
