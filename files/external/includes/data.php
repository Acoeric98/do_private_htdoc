<div class="col s12">
    <div id="data" class="card white-text grey darken-4 data-panel">
        <div class="data-panel__glow"></div>
        <div class="data-panel__content">
            <div class="data-panel__heading">
                <span class="eyebrow">Pilóta erőforrások</span>
                <p class="data-panel__subtitle">Az aktuális készleted egyetlen panelen</p>
            </div>
            <div class="data-panel__stats">
                <div class="data-panel__stat">
                    <span class="material-icons data-panel__icon">offline_bolt</span>
                    <div>
                        <span class="data-panel__label">Uridium</span>
                        <span class="data-panel__value" id="uridium"><?php echo number_format($data->uridium, 0, ',', '.'); ?></span>
                    </div>
                </div>
                <div class="data-panel__divider"></div>
                <div class="data-panel__stat">
                    <span class="material-icons data-panel__icon">credit_card</span>
                    <div>
                        <span class="data-panel__label">Credits</span>
                        <span class="data-panel__value" id="credits"><?php echo number_format($data->credits, 0, ',', '.'); ?></span>
                    </div>
                </div>
                <div class="data-panel__divider"></div>
                <div class="data-panel__stat">
                    <span class="material-icons data-panel__icon">emoji_events</span>
                    <div>
                        <span class="data-panel__label">Honor</span>
                        <span class="data-panel__value"><?php echo number_format($data->honor, 0, ',', '.'); ?></span>
                    </div>
                </div>
                <div class="data-panel__divider"></div>
                <div class="data-panel__stat">
                    <span class="material-icons data-panel__icon">trending_up</span>
                    <div>
                        <span class="data-panel__label">Experience</span>
                        <span class="data-panel__value"><?php echo number_format($data->experience, 0, ',', '.'); ?></span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
