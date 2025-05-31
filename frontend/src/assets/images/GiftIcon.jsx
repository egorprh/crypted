import React from 'react';

export default function GiftIcon() {
    return (
        <svg
            xmlns="http://www.w3.org/2000/svg"
            xmlnsXlink="http://www.w3.org/1999/xlink"
            width={18}
            height={18}
            fill="none"
        >
            <path fill="url(#gift)" d="M0 0h18v18H0z"/>
            <defs>
                <pattern
                    id="gift"
                    width={1}
                    height={1}
                    patternContentUnits="objectBoundingBox"
                >
                    <use xlinkHref="#giftb" transform="scale(.01)"/>
                </pattern>
                <image
                    xlinkHref="data:image/png;base64,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"
                    id="giftb"
                    width={100}
                    height={100}
                    preserveAspectRatio="none"
                />
            </defs>
        </svg>
    );
}
