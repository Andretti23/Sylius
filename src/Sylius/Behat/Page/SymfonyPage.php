<?php

/*
 * This file is part of the Sylius package.
 *
 * (c) Paweł Jędrzejewski
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Sylius\Behat\Page;

use Behat\Mink\Session;
use Symfony\Component\Routing\RouterInterface;

/**
 * @author Arkadiusz Krakowiak <arkadiusz.krakowiak@lakion.com>
 */
abstract class SymfonyPage extends Page
{
    /**
     * @var RouterInterface
     */
    protected $router;

    /**
     * @param Session $session
     * @param array $parameters
     * @param RouterInterface $router
     */
    public function __construct(Session $session, array $parameters, RouterInterface $router)
    {
        parent::__construct($session, $parameters);

        $this->router = $router;
    }

    /**
     * {@inheritdoc}
     */
    protected function getUrl(array $urlParameters = [])
    {
        if (null === $this->getRouteName()) {
            throw new \RuntimeException('You need to provide route name, null given');
        }

        $url = $this->router->generate($this->getRouteName(), $urlParameters);
        $url = $this->makePathAbsoluteWithBehatParameter($url);

        return $url;
    }

    /**
     * @param string $path
     *
     * @return string
     */
    protected function makePathAbsoluteWithBehatParameter($path)
    {
        $baseUrl = rtrim($this->getParameter('base_url'), '/').'/';

        return 0 !== strpos($path, 'http') ? $baseUrl.ltrim($path, '/') : $path;
    }

    /**
     * {@inheritdoc}
     *
     * Not used by Symfony page.
     */
    protected function getPath()
    {
    }

    abstract protected function getRouteName();
}
