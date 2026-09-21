'use strict';

const timelineElement = document.getElementById('timeline');

function createElement(tagName, className, text) {
    const element = document.createElement(tagName);

    if (className) {
        element.className = className;
    }

    if (text !== undefined) {
        element.textContent = text;
    }

    return element;
}

function renderTimeline(updates) {
    timelineElement.replaceChildren();

    if (!Array.isArray(updates) || updates.length === 0) {
        timelineElement.append(
            createElement('p', null, 'No project updates are available yet.')
        );

        return;
    }

    for (const update of updates) {
        const article = createElement('article', 'timeline-item');

        const meta = createElement('div', 'timeline-meta');

        meta.append(
            createElement('span', null, update.date),
            createElement('span', null, update.type),
            createElement('span', null, update.status),
            createElement('span', null, update.id)
        );

        const title = createElement('h3', null, update.title);
        const summary = createElement('p', null, update.summary);

        article.append(meta, title, summary);
        timelineElement.append(article);
    }
}

async function loadTimeline() {
    try {
        const response = await fetch('data/timeline.json', {
            cache: 'no-store'
        });

        if (!response.ok) {
            throw new Error(`HTTP ${response.status}`);
        }

        const timeline = await response.json();

        renderTimeline(timeline.updates);
    }
    catch (error) {
        console.error('Unable to load HIEP project timeline.', error);

        timelineElement.replaceChildren(
            createElement(
                'p',
                null,
                'Project timeline is currently unavailable.'
            )
        );
    }
}

loadTimeline();
