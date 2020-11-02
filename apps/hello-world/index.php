<?php

echo "Hello " . gethostname();

if (isset($_GET['slow'])) {
    sleep(5);
}
