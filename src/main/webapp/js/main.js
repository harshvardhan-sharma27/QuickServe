// QuickServe Global Client JavaScript

document.addEventListener('DOMContentLoaded', () => {
    initLiveSearch();
    initAlertAutoDismiss();
    initSlotPicker();
});

// Live Search with AJAX debouncing
function initLiveSearch() {
    const searchInputs = document.querySelectorAll('.js-live-search');
    searchInputs.forEach(input => {
        const wrapper = input.closest('.search-wrapper') || input.parentElement;
        let dropdown = wrapper.querySelector('.search-results-dropdown');
        if (!dropdown) {
            dropdown = document.createElement('div');
            dropdown.className = 'search-results-dropdown';
            wrapper.appendChild(dropdown);
        }

        let debounceTimer = null;
        input.addEventListener('input', (e) => {
            const query = e.target.value.trim();
            clearTimeout(debounceTimer);
            if (query.length < 2) {
                dropdown.style.display = 'none';
                dropdown.innerHTML = '';
                return;
            }

            debounceTimer = setTimeout(() => {
                const contextPath = input.dataset.contextPath || '';
                fetch(`${contextPath}/api/search-services?q=${encodeURIComponent(query)}`)
                    .then(res => res.json())
                    .then(data => {
                        if (!data || data.length === 0) {
                            dropdown.innerHTML = '<div class="p-3 text-muted text-center small">No matching services found.</div>';
                            dropdown.style.display = 'block';
                            return;
                        }

                        let html = '';
                        data.forEach(item => {
                            html += `
                                <div class="search-result-item" onclick="window.location.href='${contextPath}/service-details?id=${item.id}'">
                                    <div>
                                        <div class="fw-bold text-dark small">${escapeHtml(item.name)}</div>
                                        <div class="text-muted" style="font-size: 0.75rem;">${escapeHtml(item.category)} &bull; ${escapeHtml(item.provider)}</div>
                                    </div>
                                    <div class="text-end">
                                        <div class="fw-bold text-primary small">&#8377;${item.price}</div>
                                        <div class="text-warning" style="font-size: 0.7rem;"><i class="bi bi-star-fill"></i> ${item.rating}</div>
                                    </div>
                                </div>
                            `;
                        });
                        dropdown.innerHTML = html;
                        dropdown.style.display = 'block';
                    })
                    .catch(() => {
                        dropdown.style.display = 'none';
                    });
            }, 250);
        });

        // Close when clicking outside
        document.addEventListener('click', (e) => {
            if (!wrapper.contains(e.target)) {
                dropdown.style.display = 'none';
            }
        });
    });
}

function escapeHtml(text) {
    if (!text) return '';
    return text.replace(/[&<>"']/g, function(m) {
        return {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        }[m];
    });
}

// Auto dismiss alerts
function initAlertAutoDismiss() {
    const alerts = document.querySelectorAll('.alert-dismissible');
    alerts.forEach(alert => {
        setTimeout(() => {
            const bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
            if (bsAlert) bsAlert.close();
        }, 6000);
    });
}

// Dynamic slot picker
function initSlotPicker() {
    const dateInput = document.getElementById('bookingDateInput');
    const providerIdInput = document.getElementById('bookingProviderIdInput');
    const slotContainer = document.getElementById('availableSlotsContainer');

    if (!dateInput || !providerIdInput || !slotContainer) return;

    dateInput.addEventListener('change', () => {
        const date = dateInput.value;
        const providerId = providerIdInput.value;
        const contextPath = dateInput.dataset.contextPath || '';

        if (!date || !providerId) return;

        slotContainer.innerHTML = '<span class="text-muted small">Loading available slots...</span>';

        fetch(`${contextPath}/api/provider-slots?providerId=${providerId}&date=${date}`)
            .then(res => res.json())
            .then(slots => {
                if (!slots || slots.length === 0) {
                    slotContainer.innerHTML = '<span class="badge bg-light text-muted p-2">No fixed slots registered for this date. Default appointment time will be applied.</span>';
                    return;
                }

                let html = '<div class="d-flex flex-wrap gap-2">';
                slots.forEach((slot, idx) => {
                    html += `
                        <label class="btn btn-outline-primary btn-sm slot-btn">
                            <input type="radio" name="availabilityId" value="${slot.id}" class="d-none" ${idx === 0 ? 'checked' : ''} onchange="updateBookingTime('${slot.startTime}')">
                            <i class="bi bi-clock me-1"></i> ${slot.startTime} - ${slot.endTime}
                        </label>
                    `;
                });
                html += '</div>';
                slotContainer.innerHTML = html;

                // Set initial time
                if (slots.length > 0) {
                    updateBookingTime(slots[0].startTime);
                }
            })
            .catch(() => {
                slotContainer.innerHTML = '<span class="text-muted small">Could not load slots.</span>';
            });
    });
}

function updateBookingTime(timeStr) {
    const timeInput = document.getElementById('bookingTimeInput');
    if (timeInput) {
        timeInput.value = timeStr;
    }
}
